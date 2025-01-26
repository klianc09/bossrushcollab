extends Node

var mainNode : Node
var camera : MainCamera
var particlePool = {}
var sfxNodes = {}

var viewportSize : Vector2
var bossNode : Enemy

## Emitted when a new Boss spawns and becomes the current boss.
signal boss_spawned(bossNode: Enemy)
## Emitted when the current Boss's health changes (damage or healing).
signal boss_hp_changed(newHealth: float)
## Emitted when the current Boss has been defeated.
signal boss_defeated()
## Emitted when ALL bosses have been defeated.
signal great_success()

func _enter_tree() -> void:
	viewportSize = get_viewport().get_visible_rect().size

func resetPools() -> void:
	particlePool = {}

func createParticle(scene_name: String) -> Node2D:
	if not particlePool.has(scene_name):
		particlePool[scene_name] = []
	var particle
	if particlePool[scene_name].is_empty():
		particle = load(scene_name).instantiate()
		mainNode.add_child(particle)
	else:
		particle = particlePool[scene_name].pop_back()
		particle.visible = true
		particle.timer = 0
	return particle

func returnToPool(particle: PoolableParticle) -> void:
	particle.visible = false
	particlePool[particle.scene_file_path].push_back(particle)

func bossSpawned(boss: Enemy):
	if is_instance_valid(bossNode):
		printerr("WARNING: spawning a boss while another one is still alive, make sure the boss checkbox is only set for one enemy node in your bossfight scene")
	bossNode = boss
	emit_signal("boss_spawned", bossNode)

func damageBoss(damageAmount: float):
	if not is_instance_valid(bossNode):
		return
	bossNode.hp -= damageAmount
	if bossNode.hp < 0:
		bossNode.hp = 0
	emit_signal("boss_hp_changed", bossNode.hp)

func healBoss(healAmount: int):
	bossNode.hp += healAmount
	if bossNode.hp > bossNode.maxhp:
		bossNode.hp = bossNode.maxhp
	emit_signal("boss_hp_changed", bossNode.hp)

func bossFightOver():
	emit_signal("boss_defeated")

func screenshake(amount: float):
	camera.shake(amount)

func maintainScreenshake(amount: float):
	camera.maintainShake(amount)

func screenDirectionalKnockback(push: Vector2):
	camera.directionalPush(push)

# for sfx that cannot be attached to an object that's gonna be deleted (like a bullet)
func register_sfx(sfxName: String, sfxNode: AudioStreamPlayer):
	sfxNodes[sfxName] = sfxNode

func playSfx(sfxName:String):
	if sfxNodes.has(sfxName):
		if not is_instance_valid(sfxNodes[sfxName]):
			sfxNodes.erase(sfxName)
		else:
			sfxNodes[sfxName].play()
