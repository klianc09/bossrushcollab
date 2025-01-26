extends Enemy

var moveSpeed = 300
var velocity = Vector2(0, -moveSpeed)
var radius = 0
var rotateSpeed = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	rotate(rotateSpeed * delta)
	position += velocity * delta
	var hit = false
	if position.x < radius and velocity.x < 0:
		velocity = Vector2(0, moveSpeed)
		position.x = radius
		hit = true
	elif position.x > Singleton.viewportSize.x - radius and velocity.x > 0:
		velocity = Vector2(0, -moveSpeed)
		position.x = Singleton.viewportSize.x -radius
		hit = true
	if position.y < radius and velocity.y < 0:
		velocity = Vector2(-moveSpeed, 0)
		position.y = radius
		hit = true
	elif position.y > Singleton.viewportSize.y - radius and velocity.y > 0:
		velocity = Vector2(moveSpeed, 0)
		position.y = Singleton.viewportSize.y -radius
		hit = true
	if hit:
		$bounceSfx.play()
		Singleton.screenDirectionalKnockback(velocity.normalized() * 5)
