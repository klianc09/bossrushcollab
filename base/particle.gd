class_name PoolableParticle
extends Sprite2D

var duration = 0.1
var timer = 0

func _process(delta: float) -> void:
	timer += delta
	if timer >= duration:
		Singleton.returnToPool(self)
