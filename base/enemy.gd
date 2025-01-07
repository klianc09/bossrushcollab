class_name Enemy
extends Area2D

@export var boss_name : String = "Unnamed Boss"
@export var maxhp : float = 1
var hp : float = 1
@export var validTarget : bool = true
@export var boss : bool = false
@export var multipart : bool = false ## TODO figure out how to do multipart bosses as well as weakspots in a flexible and simple way
@export var damageMultiplier : float = 1
@export var contactDamage : int = 1
@export var destroyedOnContact : bool = false
@export var invincible : bool = false

var flashDuration = 0.1
var flashTimer = 0

func _ready() -> void:
	hp = maxhp
	if boss:
		Singleton.bossSpawned(self)

func _process(delta: float) -> void:
	flashTimer -= delta
	if flashTimer < 0:
		modulate = Color.WHITE
	
	if hp <= 0:
		onHealthFullyLost()

func onHealthFullyLost() -> void:
	if boss:
		Singleton.bossFightOver()
	queue_free()

func damage(amount: float) -> void:
	if invincible:
		return
	if (boss or multipart):
		Singleton.damageBoss(amount * damageMultiplier)
	else:
		hp -= amount * damageMultiplier
	modulate = Color.WHITE * 3
	flashTimer = flashDuration

func onContactWithPlayer(player: Player) -> void:
	player.damage(contactDamage)
	if destroyedOnContact:
		queue_free()
