class_name Player
extends Area2D

var maxHealth = 3
var health = maxHealth
var moveSpeed = 200
var focusSpeed = 400
var barrageSpeed = 50

var fireRateTimer = 0
var fireRate = 0.08

var chargeConversationRate = 0.08
var chargeTimer = 0
var chargeDischarge = 0
var chargeRate = 1
var dischargeRate = 2

var bulletSpeed = 1800
var missileSpeed = 900
var minBulletSpread = 1
var maxBulletSpread = 11
var minBulletSubSpread = 0
var maxBulletSubSpread = 8
var minMissileSpread = 15
var maxMissileSpread = 70
var minMissileSubSpread = 10
var maxMissileSubSpread = 30
var spreadValue = 0
var spreadLerpAlpha = 3
var alternate = 1
var bulletSpawnOffset = 50

@export var damageMultiplier = 1

signal health_change(node: Player)
signal charge_change(node: Player)

func _ready() -> void:
	health_change.emit(self)
	charge_change.emit(self)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_reset"):
		Singleton.resetPools()
		get_tree().reload_current_scene()
	var input_x = Input.get_axis("ui_left", "ui_right")
	var input_y = Input.get_axis("ui_up", "ui_down")
	var input_vector = Vector2(input_x, input_y)
	
	# spreadValue = lerpf(spreadValue, input_x, spreadLerpAlpha)
	spreadValue = move_toward(spreadValue, input_x, spreadLerpAlpha * delta)
	$Reticle/r1.position.y = (spreadValue-1) * 30 - 5
	$Reticle/r2.position.y = -(spreadValue-1) * 30 + 5
	
	var spread = remap(spreadValue, -1, 1, maxBulletSpread, minBulletSpread)
	var spread2 = remap(spreadValue, -1, 1, maxBulletSubSpread, minBulletSubSpread)
	var spreadM = remap(spreadValue, -1, 1, maxMissileSpread, minMissileSpread)
	var spreadM2 = remap(spreadValue, -1, 1, maxMissileSubSpread, minMissileSubSpread)
	
	var currentMoveSpeed = moveSpeed
	if !Input.is_action_pressed("action_focus"):
		currentMoveSpeed = focusSpeed
		chargeTimer += delta * chargeRate
		chargeDischarge = chargeConversationRate # guaranteed missiles at start of barrage
		charge_change.emit(self)
	else:
		if chargeTimer > 0:
			currentMoveSpeed = barrageSpeed
			chargeDischarge += delta
			chargeTimer -= delta * dischargeRate
			if chargeDischarge >= chargeConversationRate:
				chargeDischarge -= chargeConversationRate
				spawnMissile(position, Vector2(missileSpeed, 0).rotated(deg_to_rad(randf_range(-spreadM2, spreadM2) + spreadM)))
				spawnMissile(position, Vector2(missileSpeed, 0).rotated(deg_to_rad(randf_range(-spreadM2, spreadM2) - spreadM)))
			if chargeTimer <= 0:
				chargeTimer = 0
				# guaranteed missiles at end of barrage
				# spawnMissile(position, Vector2(missileSpeed, 0).rotated(deg_to_rad(spreadM)))
				# spawnMissile(position, Vector2(missileSpeed, 0).rotated(deg_to_rad(-spreadM)))
				# end of barrage
			charge_change.emit(self)
		else:
			fireRateTimer += delta
			if fireRateTimer >= fireRate:
				fireRateTimer -= fireRate
				var fireDir = Vector2(bulletSpeed, 0).rotated(deg_to_rad(randf_range(-spread2, spread2) + spread * alternate))
				spawnBullet(position, fireDir)
				alternate = -alternate
			
	position += input_vector * delta * currentMoveSpeed
	#clamp to screen
	position = position.clamp(Vector2.ZERO, Singleton.viewportSize)
	

func spawnBullet(position_: Vector2, velocity: Vector2):
	var bulletScene : PackedScene = load("res://player/bullet.tscn")
	var bullet = bulletScene.instantiate()
	bullet.position = position_ + velocity.normalized() * bulletSpawnOffset
	bullet.bulletSpeed = velocity.length()
	bullet.rotation = velocity.angle()
	bullet.damage *= damageMultiplier
	Singleton.mainNode.add_child(bullet)
	var particle = Singleton.createParticle("res://base/particle.tscn")
	particle.position = bullet.position
	return bullet

func spawnMissile(position_: Vector2, velocity: Vector2):
	var bulletScene : PackedScene = load("res://player/missile.tscn")
	var missile = bulletScene.instantiate()
	missile.position = position_ + velocity.normalized() * bulletSpawnOffset
	missile.bulletSpeed = velocity.length()
	missile.rotation = velocity.angle()
	missile.damage *= damageMultiplier
	Singleton.mainNode.add_child(missile)
	var particle = Singleton.createParticle("res://base/particle.tscn")
	particle.position = missile.position
	return missile

func damage(damageAmount: int) -> void:
	health -= damageAmount
	health_change.emit(self)

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		area.onContactWithPlayer(self)
