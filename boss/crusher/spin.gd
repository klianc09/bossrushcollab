extends Sprite2D

@export
var spinAmount = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(spinAmount * delta)
