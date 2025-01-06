class_name MainCamera
extends Camera2D

var shakeStrength : float
var shakeOffset : Vector2
var shakeTimer : float = 0
@export var shakeInterval : float = 0.016
@export var shakeFalloff : float = 5
var directionalStrength : Vector2
@export var directionalFalloff : float = 10

func _ready() -> void:
	Singleton.camera = self

func _process(delta: float) -> void:
	# random offset
	shakeTimer += delta
	shakeStrength *= 1 / (1 + shakeFalloff * delta)
	if shakeTimer > shakeInterval:
		shakeTimer -= shakeInterval
		shakeOffset = Vector2(randf_range(-shakeStrength, shakeStrength), randf_range(-shakeStrength, shakeStrength))
	# directional knockback
	directionalStrength *= 1 / (1 + directionalFalloff * delta)
	# add all screenshake vectors together for combined result
	offset = shakeOffset + directionalStrength

func shake(force: float):
	shakeStrength += force

func maintainShake(shakeLevel: float):
	if shakeStrength < shakeLevel:
		shakeStrength = shakeLevel

func directionalPush(push: Vector2):
	directionalStrength += push
