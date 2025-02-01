extends Enemy

var rotate_speed : float = 0
var rotate_friction : float = 1
var rotate_slowdown : float = 2
var max_rotate_speed : float = 50
var push_per_damage : float = 2
var locked : bool = false
var initial_push_min : float = 20
var initial_push_max : float = 20
var has_been_pushed : bool = false

var list_of_bosses = []
var wheel_segments
var current_segment = 0

var pointer_wiggle = 0.0

@onready
var anchor = position

@onready
var iconsContainer = $rotate/Icons

## The wheel stopped spinning and has selected the next boss
signal locked_in(boss: Enemy)

func show_wheel():
	position = anchor + Vector2(0, -Singleton.viewportSize.y)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", anchor, 0.5)
	tween.tween_callback(activate)
	invincible = true

func activate():
	$impactSfx.play()
	Singleton.screenshake(4)
	Singleton.screenDirectionalKnockback(Vector2(0, 10))
	invincible = false
	validTarget = true

func hide_wheel():
	var pos = anchor + Vector2(0, -Singleton.viewportSize.y)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", pos, 0.4)
	validTarget = false

func setup_wheel(list_of_bosses):
	self.list_of_bosses = list_of_bosses
	wheel_segments = {}
	$Icon.visible = true
	$line.visible = true
	for node in iconsContainer.get_children():
		node.queue_free()
	var i = 0
	for boss in list_of_bosses:
		var icon = $Icon.duplicate()
		var radians = deg_to_rad(i * 360.0 / len(list_of_bosses))
		icon.position = icon.position.rotated(radians)
		var boss_icon = boss.boss_icon
		if boss_icon == null:
			boss_icon = load("res://icon.svg")
		icon.texture = boss_icon
		icon.rotation = radians
		iconsContainer.add_child(icon)
		wheel_segments[boss] = radians
		i += 1
		var line = $line.duplicate()
		line.rotation = deg_to_rad((i+0.5) * 360.0 / len(list_of_bosses))
		iconsContainer.add_child(line)
	$Icon.visible = false
	$line.visible = false
	has_been_pushed = false
	locked = false

func _process(delta: float) -> void:
	super(delta)
	if len(list_of_bosses) <= 0:
		return
	rotate_speed = move_toward(rotate_speed, 0, rotate_slowdown * delta)
	rotate_speed *= 1 / (1 + rotate_friction * delta)
	var halfSegmentAngle = deg_to_rad(180.0 / len(list_of_bosses))
	$rotate.rotation += rotate_speed * delta
	var new_segment = (-$rotate.rotation - halfSegmentAngle) / (halfSegmentAngle * 2)
	new_segment = posmod(new_segment, len(list_of_bosses))
	if current_segment != new_segment:
		$clickSfx.play()
		if (pointer_wiggle <= 0):
			pointer_wiggle = 1.0
			var tween = get_tree().create_tween()
			tween.tween_property(self, "pointer_wiggle", 0.0, 0).set_delay(0.05)
	current_segment = new_segment
	if rotate_speed <= 0 and has_been_pushed and not locked:
		locked = true
		locked_in.emit(list_of_bosses[current_segment])
	$WheelPointer.rotation = -pointer_wiggle

func damage(amount):
	if locked or invincible:
		return
	if has_been_pushed:
		rotate_speed += amount * push_per_damage
	else:
		has_been_pushed = true
		rotate_speed += randf_range(initial_push_min, initial_push_max) * push_per_damage
	rotate_speed = min(max_rotate_speed, rotate_speed)
	super(amount)
