extends Control

var mainTween : Tween
var progressing = false

var speedScale = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("action_focus"):
		speedScale += speedScale * delta
	else:
		speedScale = move_toward(speedScale, 1, delta * 2)
	if mainTween != null:
		mainTween.set_speed_scale(speedScale)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if not progressing:
			progressing = true
			var tween = get_tree().create_tween()
			mainTween = tween
			tween.tween_property($ColorRect, "modulate", Color.WHITE, 1)
			tween.parallel().tween_property($Credits, "position", $Credits.position + Vector2(0, -2600), 20)
			tween.tween_callback(loadMainScene)
		else:
			speedScale = speedScale + 1

func loadMainScene():
	Singleton.resetScene()
