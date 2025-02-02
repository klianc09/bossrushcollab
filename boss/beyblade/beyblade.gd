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
var spawning = true
var end = false

enum P {
	MOVE, OUTRO
}

func _ready():
	super()
	position = Vector2(Singleton.viewportSize.x + radius * 4, Singleton.viewportSize.y / 2)
	position.y = randf_range(0, Singleton.viewportSize.y)
	rotation_degrees = randf_range(-60, 60)
	activateTurrets(false)
	activateLaser(false)
	$mainTurret.burst_data = $mainTurret.burst_data.duplicate() #edit_resource_workaround

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
	
	if not end:
		time += delta
	var sinValue = sin(time)
	bladeExtension = max(0, sinValue * maxExtension)
	
	rotation += delta * spinSpeed
	if sinValue < 0:
		rotation += delta * -sinValue * extraSpin
		if phase == P.MOVE:
			if hp < maxhp * 0.75:
				activateTurrets(true)
			if hp < maxhp * 0.25:
				$mainTurret.burst_data.time_between_bursts = 0.25 #edit_resource_workaround: doing this apparently permanently alters the resource???
			else:
				activateLaser(false)
		elif phase == P.OUTRO:
			end = true
	else:
		if phase == P.MOVE:
			resetTurrets()
			activateTurrets(false)
			activateLaser(true)
	if phase == P.OUTRO:
		Singleton.maintainScreenshake(3)
	var extra = 1
	if sinValue < 0:
		extra = 1 + -sinValue * extraSpeed
	position += delta * velocity * extra
	if phase == P.MOVE:
		var hit = false
		if position.x < radius and velocity.x < 0:
			velocity.x *= -1
			position.x = radius
			spawning = false
			hit = true
		elif position.x > Singleton.viewportSize.x - radius and velocity.x > 0:
			velocity.x *= -1
			if not spawning:
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
			$impactSfx.play()

func onHealthFullyLost():
	if phase != P.OUTRO:
		phase = P.OUTRO
		activateTurrets(false)
		activateLaser(false)
		var tween = get_tree().create_tween()
		tween.tween_callback(despawn).set_delay(5)

func despawn():
	Singleton.screenshake(10)
	Singleton.bossFightOver()
	queue_free()
