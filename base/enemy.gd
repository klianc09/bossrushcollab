class_name Enemy
extends Area2D

## Name of this enemy, mainly used to display the name of the boss in the intro sequence.
@export var boss_name : String = "Unnamed Boss"
## Icon used to represent this boss for the wheel of unfortune
@export var boss_icon : Texture2D
## The color the background gets tinted for this fight
@export var boss_bg_color : Color = Color.WHITE
## The maximum HP of this enemy. Enemies will spawn with full hp when added to the scene tree.
@export var maxhp : float = 1
var hp : float = 1
## Whether this is a valid target for homing missiles.
@export var validTarget : bool = true
## Exactly one node in the scene should have this set to true, it will get registered as the current boss to defeat.
@export var boss : bool = false
## Set this true for parts of multipart bosses. When this is true, the part will not take damage itself, but instead the damage will be redirected to the current boss. Combine with damageMultiplier to create weakspots.
@export var multipart : bool = false
## Any incoming damage is multiplied by this.
@export var damageMultiplier : float = 1
## The damage this deals to the player when the player touches this.
@export var contactDamage : int = 1
## Whether this enemy is destroyed upon impact with the player.
@export var destroyedOnContact : bool = false
## As long as this is set to true, this enemy cannot take damage. Use for temporary invincibility e.g. during phase transitions. (multiparts will also not redirect damage while this is active)
@export var invincible : bool = false

var flashDuration = 0.1
var flashTimer = 0

func _ready() -> void:
	hp = maxhp
	collision_layer = 4
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
