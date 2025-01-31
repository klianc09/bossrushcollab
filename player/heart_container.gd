extends HBoxContainer

var tweener : Tween

func _ready() -> void:
	showHearts()

func showHearts():
	if tweener != null:
		tweener.stop()
	tweener = get_tree().create_tween()
	tweener.tween_property(self, "modulate", Color.WHITE, 0.1)
	tweener.tween_property(self, "modulate", Color.TRANSPARENT, 0.1).set_delay(1)


func _on_player_health_change(node: Player) -> void:
	$Heart1.texture = heart_texture(node.health > 0)
	$Heart2.texture = heart_texture(node.health > 1)
	$Heart3.texture = heart_texture(node.health > 2)
	showHearts()

func heart_texture(healthy):
	if healthy:
		return load("res://player/gfx/heart.png")
	else:
		return load("res://player/gfx/heart_broken.png")
