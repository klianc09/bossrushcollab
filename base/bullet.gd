class_name Bullet
extends Area2D

@export var enemy_team = true
@export var bulletSpeed = 100
@export var maxLifetime = 5
@export var damage = 1
var timer = 0
@export var homing = false
@export var homing_group = "enemy"
@export var rotationSpeed = 3
@export var speedup = 0
var target : Node2D
var homingDelay = 0

func _ready() -> void:
	# collision layers:
	# Layer 1 (1): Player
	# Layer 2 (2): Player Bullets
	# Layer 3 (4): Enemies
	# Layer 4 (8): Enemy Bullets
	if enemy_team:
		collision_layer = 8
		collision_mask = 1
	else:
		collision_layer = 2
		collision_mask = 4
	# automatically hook up signals
	connect("area_entered", _on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	homingDelay -= delta
	if homing and homingDelay <= 0:
		if target == null or not is_instance_valid(target) or (target.get("validTarget") and not target.validTarget):
			target = searchForNewTarget()
			if target == null:
				homingDelay = 1
		else:
			var targetRotation = (target.global_position - position).angle()
			rotation = rotate_toward(rotation, targetRotation, rotationSpeed * delta)
	var forward = Vector2(1, 0).rotated(rotation)
	bulletSpeed += speedup * delta
	position += forward * bulletSpeed * delta
	timer += delta
	if timer >= maxLifetime:
		despawn(true)

func despawn(timeout: bool) -> void:
	var particle = Singleton.createParticle("res://base/particle.tscn")
	particle.position = position
	queue_free()

func searchForNewTarget() -> Node2D:
	var enemies = get_tree().get_nodes_in_group(homing_group)
	if enemies.is_empty():
		return null
	return enemies.pick_random()

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy or area is Player:
		area.damage(damage)
		despawn(false)
