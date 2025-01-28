extends Enemy
var movementDirection
var bulletSpeed = 15
var rotateSpeed = 90
var lifeTime = 2
var lifeTimer=0
func _ready() -> void:
	lifeTime = randf_range(1.5,2.5)
	super() # very important to call the base function (from the enemy script)
	movementDirection = Vector2(0, 1).rotated(rotation)
func onHealthFullyLost():
	super()
func _process(delta: float) -> void:
	super(delta) # very important to call the base function (from the enemy script)
	position += movementDirection * bulletSpeed * delta
	rotation_degrees += rotateSpeed * delta
	lifeTimer+=delta
	if(lifeTimer>=lifeTime):
		$Turret1.shoot()
		$Turret2.shoot()
		$Turret3.shoot()
		$Turret4.shoot()
		$"../ExampleBoss1/Death".play()
		onHealthFullyLost()
