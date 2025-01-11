extends Bullet

## the time it takes before the laser activates its hitbox
@export var chargeDuration : float = 2

func _ready() -> void:
	super()
	scale.y = 0.05
	var tween = get_tree().create_tween()
	var animationDuration = 0.1
	tween.tween_property(self, "scale", Vector2(1, 1), animationDuration).set_delay(chargeDuration - animationDuration)
	tween.tween_callback(activate)

func activate():
	$CollisionShape2D.set_deferred("disabled", false)
