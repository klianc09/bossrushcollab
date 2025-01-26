extends Enemy

var forward = Vector2(1, 0)
var bulletSpeed = 300
var radius = 32
var velocity = Vector2()
var rotationSpeed = 20

func _ready() -> void:
	super()
	velocity = forward.rotated(rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(rotationSpeed * delta)
	position += velocity * bulletSpeed * delta
	var hit = false
	if position.x < radius and velocity.x < 0:
		velocity.x *= -1
		position.x = radius
		hit = true
	elif position.x > Singleton.viewportSize.x - radius and velocity.x > 0:
		velocity.x *= -1
		position.x = Singleton.viewportSize.x -radius
		hit = true
	if position.y < radius and velocity.y < 0:
		velocity.y *= -1
		position.y = radius
		hit = true
	elif position.y > Singleton.viewportSize.y - radius and velocity.y > 0:
		velocity.y *= -1
		position.y = Singleton.viewportSize.y -radius
		hit = true
	if hit:
		Singleton.playSfx("bounceSfx")
	super(delta)
