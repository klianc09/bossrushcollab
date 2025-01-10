extends Node2D

## List of all bosses. Bosses to fight will be picked randomly from this list.
@export var bosses: Array[PackedScene]
## Set your scene here (for testing) to override the list of bosses.
@export var testBoss : PackedScene
var remainingBosses = []

func _enter_tree() -> void:
	Singleton.mainNode = self

func _ready() -> void:
	if testBoss != null:
		remainingBosses.push_back(testBoss)
	else:
		for boss in bosses:
			remainingBosses.push_back(boss)
	Singleton.connect("boss_defeated", _on_boss_defeated)
	$NextBossTimer.start()

func spawn_new_boss() -> void:
	if remainingBosses.is_empty():
		Singleton.emit_signal("great_success")
	else:
		var nextBoss = remainingBosses.pick_random()
		remainingBosses.erase(nextBoss)
		Singleton.mainNode.add_child(nextBoss.instantiate())

func _on_next_boss_timer_timeout() -> void:
	spawn_new_boss()

func _on_boss_defeated():
	$NextBossTimer.start()
