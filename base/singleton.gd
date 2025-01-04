extends Node

var mainNode : Node
var particlePool = {}

var bossNode : Enemy

signal boss_hp_changed(newHealth: int)
signal boss_defeated()
signal boss_spawned(bossNode: Enemy)
signal great_success()

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

func damageBoss(damageAmount: int):
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
	#TODO: some transition / outro whatever might happen here
