extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart()
	$sparks.restart()
	var scene = load("res://player/debris.tscn")
	for i in range(5):
		var debri = scene.instantiate()
		debri.linear_velocity = Vector2(0, -randf_range(700, 1500)).rotated(randf_range(-1, 1) * PI * 0.5)
		add_child(debri)


func _on_timer_timeout() -> void:
	queue_free()
