extends Enemy

var movement = 100
var horizontalPosition = Singleton.viewportSize.x - 100
var verticalEdgeToBorder = 100

enum Phase {
	START,MIDDLE,END,NAKED,DEATH
}
var leftWallDown=false
var rightWallDown=false
var bottomWallDown=false
var phase = Phase.START
var laserCooldownTime = 5
var laserCooldownTimer = 5
@export var MiddleSprite : Texture

@export var EndSprite : Texture


@export var DeathSprite : Texture
func _ready() -> void:
	super() # very important to call the base function (from the enemy script)
	
	position.x = Singleton.viewportSize.x
	position.y = Singleton.viewportSize.y / 2

func onHealthFullyLost() -> void:
	if(phase!=Phase.DEATH):
		phase=Phase.DEATH
		$GPUParticles2D/AudioStreamPlayer2D.play()
		laserCooldownTime = 2
		laserCooldownTimer = laserCooldownTime
		$FlowerTimer.stop()
		$OutroTimer.start()
		$"Main Sprite".texture=DeathSprite
		$Flowers_Pink.hide()
		$Flowers_Yellow.hide()
		$Buds.hide()
		$GPUParticles2D.show()
	#if phase == Phase.PHASE1:
		#phase = Phase.TRANSITION
		#hp = maxhp
		#Singleton.screenDirectionalKnockback(Vector2(-20, 0))
		#$Turret1.active = false
		#$Turret2.active = false
		#var tween = get_tree().create_tween()
		#tween.tween_property(self, "modulate", Color.RED, 0.5)
		#tween.tween_property(self, "modulate", Color.WHITE, 0.5)
		#tween.tween_property(self, "modulate", Color.RED, 0.5)
		#tween.tween_property(self, "modulate", Color.WHITE, 0.5)
		#$TransitionTimer.start()
	#elif phase == Phase.PHASE2:
		#phase = Phase.OUTRO
		#$MainTurret.active = false
		#var tween = get_tree().create_tween().set_parallel(true)
		#tween.tween_property(self, "modulate", Color.BLACK, 0.5)
		#tween.tween_property(self, "scale", Vector2(0, 0), 1)
	
		


func _process(delta: float) -> void:
	super(delta) # very important to call the base function (from the enemy script)
	
	#laser shit happens independant of phase
	if(laserCooldownTimer>0 and phase!=Phase.DEATH):
		laserCooldownTimer -= delta
		if(laserCooldownTimer<=0):
			if(leftWallDown and rightWallDown and bottomWallDown):
				$LaserTurret.shoot();
				$LaserTurret2.shoot();
				$LaserTurret3.shoot();
				$LaserTurret4.shoot();
				laserCooldownTimer = laserCooldownTime * 3
			else:
				var angleToPlayer = (position-get_tree().get_nodes_in_group("player").pop_front().position).angle()
				angleToPlayer = fposmod(rad_to_deg(angleToPlayer), 360.0)
				
				if((angleToPlayer>0 and angleToPlayer<=45) or (angleToPlayer>315 and angleToPlayer<=360)):
					$LaserTurret.shoot();
				elif(angleToPlayer>45 and angleToPlayer<=135 and rightWallDown):
					$LaserTurret2.shoot();
				elif(angleToPlayer>135 and angleToPlayer<=225 and bottomWallDown):
					$LaserTurret4.shoot();
				elif(angleToPlayer>225 and angleToPlayer<=315 and leftWallDown):	
					$LaserTurret3.shoot();
				laserCooldownTimer = laserCooldownTime
			#these ones will only fire if the respective walls are down
			
	if phase == Phase.START:
		if(position.x > Singleton.viewportSize.x - 500):
			position.x -= 20 * delta
		rotation_degrees -= delta * 20
		_normalGuns()
		if(hp<=maxhp *.7):
			phase = Phase.MIDDLE
			$FlowerTimer.start()
			laserCooldownTime -= 1
			$Flowers_Pink.show()
			$Flowers_Yellow.show()
			$"Main Sprite".texture=MiddleSprite
	
	elif phase == Phase.MIDDLE:
		rotation_degrees -= delta * 35
		$Flowers_Pink.modulate = Color(fposmod(rotation_degrees*delta, 1),fposmod(rotation_degrees*delta, 1),.5)
		$Flowers_Yellow.modulate = Color(.5,fposmod(rotation_degrees*delta, 1),fposmod(rotation_degrees*delta, 1))
		if(hp<=maxhp *.3):
			phase = Phase.END
			laserCooldownTime -= 1
			$"Main Sprite".texture=EndSprite
			
	elif phase == Phase.END:
		rotation_degrees -= delta * 60
		$Flowers_Pink.modulate = Color(fposmod(rotation_degrees*delta, 1),fposmod(rotation_degrees*delta, 1),1)
		$Flowers_Yellow.modulate = Color(1,fposmod(rotation_degrees, 1),fposmod(rotation_degrees*delta, 1))
		$Buds.modulate = Color(fposmod(rotation_degrees*delta, 1),1,fposmod(rotation_degrees*delta, 1))
		_normalGuns()
		#_normalGuns() #turned out to be very unnessecary
	elif phase == Phase.DEATH:
		position.y += 40 * delta
		position.x -= 30 * delta
		rotation_degrees -= delta * 200
		if(laserCooldownTimer>0):
			laserCooldownTimer -= delta
			if(laserCooldownTimer<=0):
				var pick = randi_range(0,4)
				if(pick == 0):	
					$LaserTurret.shoot();
				if(pick == 1):
					$LaserTurret3.shoot();
				if(pick == 2):
					$LaserTurret4.shoot();
				if(pick == 3):
					$LaserTurret2.shoot();
				laserCooldownTimer = laserCooldownTime
func _normalGuns():
	
	rotation_degrees = fposmod(rotation_degrees, 360.0)
	if abs( rotation_degrees - 180 ) < 15:
		if(phase != Phase.MIDDLE && $Flowers_Pink.hidden):
				$Flowers_Pink.show()
				$BloomTimerPink.start()
		var pick = randi_range(0,12)
		if pick==0:
			$"phase 1 guns/Turret1".shoot();
			
		elif pick==1:
			$"phase 1 guns/Turret2".shoot();
	if abs( rotation_degrees ) < 15:
		if(phase != Phase.MIDDLE && $Flowers_Pink.hidden):
				$Flowers_Pink.show()
				$BloomTimerPink.start()
		var pick = randi_range(0,12)
		if pick==0:
			$"phase 1 guns/Turret1".shoot();
		elif pick==1:
			$"phase 1 guns/Turret2".shoot();
	if abs( rotation_degrees - 90 ) < 15:
		if(phase != Phase.MIDDLE && $Flowers_Yellow.hidden):
				$Flowers_Yellow.show()
				$BloomTimerYellow.start()
		var pick = randi_range(0,24)
		if pick==0:
			$"phase 1 guns/Turret3".shoot();
		elif pick==1:
			$"phase 1 guns/Turret4".shoot();
	if abs( rotation_degrees - 270 ) < 15:
		if(phase != Phase.MIDDLE && $Flowers_Yellow.hidden):
				$Flowers_Yellow.show()
				$BloomTimerYellow.start()
		var pick = randi_range(0,24)
		if pick==0:
			$"phase 1 guns/Turret3".shoot();
		elif pick==1:
			$"phase 1 guns/Turret4".shoot();

#func _on_pause_timer_timeout() -> void:
#phase = Phase.PHASE1
#Singleton.screenDirectionalKnockback(Vector2(20, 0))
#invincible = false
#$CritArea.invincible = false
#$Turret1.active = true
#$Turret2.active = true

#func _on_transition_timer_timeout() -> void:
#phase = Phase.PHASE2
#movement = 200
#$MainTurret.active = true
#Singleton.screenDirectionalKnockback(Vector2(20, 0))

func _on_outro_timer_timeout() -> void:
	Singleton.screenDirectionalKnockback(Vector2(0, 10))
	Singleton.bossFightOver()
	queue_free()


func _on_flower_timer_timeout():
	var pick = randi_range(0,3)
	if(pick == 0):
		$"phase 2 guns/Turret1".shoot()
	if(pick == 1):
		$"phase 2 guns/Turret2".shoot()
	if(pick == 2):
		$"phase 2 guns/Turret3".shoot()
	if(pick == 3):
		$"phase 2 guns/Turret4".shoot()
	


func _on_left_dead():
	leftWallDown = true
	$LaserTurret3.shoot();
	if(rightWallDown and bottomWallDown):
		$"Pot Front".hide()
	pass # Replace with function body.


func _on_right_dead():
	rightWallDown = true
	$LaserTurret2.shoot();
	if(leftWallDown and bottomWallDown):
		$"Pot Front".hide()
	pass # Replace with function body.


func _on_back_dead():
	bottomWallDown = true
	$LaserTurret4.shoot();
	if(rightWallDown and leftWallDown):
		$"Pot Front".hide()
	pass # Replace with function body.


func _on_bloom_timer_timeout():
	if(phase!=Phase.MIDDLE):
		$Flowers_Pink.hide()
	pass # Replace with function body.


func _on_bloom_timer_yellow_timeout():
	if(phase!=Phase.MIDDLE):
		$Flowers_Yellow.hide()
	pass # Replace with function body.
	pass # Replace with function body.
