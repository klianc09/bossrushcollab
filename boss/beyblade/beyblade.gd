extends Enemy

var bladeExtension : float = 0
var maxExtension : float = 300
var time : float = PI
var velocity : Vector2 = Vector2(100, 100)
var radius : float = 50
var spinSpeed : float = 1
var extraSpin : float = 15
var extraSpeed : float = 1.5

var phase : P = P.MOVE

enum P {
	MOVE, ARTILLERY
}

func _ready():
	super()
	position = Vector2(Singleton.viewportSize.x + radius, Singleton.viewportSize.y / 2)
	position.y = randf_range(0, Singleton.viewportSize.y)
	rotation_degrees = randf_range(-30, 30)
	activateTurrets(false)

func resetTurrets():
	$Blade1/t1.reset()
	$Blade1/t2.reset()
	$Blade1/t3.reset()
	$Blade2/t1.reset()
	$Blade2/t2.reset()
	$Blade2/t3.reset()

func activateTurrets(active: bool):
	$Blade1/t1.active = active
	$Blade1/t2.active = active
	$Blade1/t3.active = active
	$Blade2/t1.active = active
	$Blade2/t2.active = active
	$Blade2/t3.active = active

func activateLaser(active: bool):
	$mainTurret.active = active

func _process(delta: float):
	super(delta)
	$Blade1.position = Vector2(0, -bladeExtension)
	$Blade2.position = Vector2(0, bladeExtension)
	
	time += delta
	var sinValue = sin(time)
	bladeExtension = max(0, sinValue * maxExtension)
	
	rotation += delta * spinSpeed
	if sinValue < 0:
		rotation += delta * -sinValue * extraSpin
		if hp < maxhp * 0.75:
			activateTurrets(true)
		if hp < maxhp * 0.25:
			$mainTurret.burst_data.time_between_bursts = 0.25
		else:
			activateLaser(false)
	else:
		resetTurrets()
		activateTurrets(false)
		activateLaser(true)
	
	if phase == P.MOVE:
		var extra = 1
		if sinValue < 0:
			extra = 1 + -sinValue * extraSpeed
		position += delta * velocity * extra
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
			Singleton.screenshake(12)
