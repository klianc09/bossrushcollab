extends Node2D

## List of all bosses. Bosses to fight will be picked randomly from this list.
@export var bosses: Array[PackedScene]
## Set your scene here (for testing) to override the list of bosses.
@export var testBoss : PackedScene
var remainingBosses = []
var nextBoss

@onready
var wheel = $WheelOfUnfortune

func _enter_tree() -> void:
	Singleton.mainNode = self

func _ready() -> void:
	if testBoss != null:
		remainingBosses.push_back(testBoss.instantiate())
	else:
		for boss in bosses:
			remainingBosses.push_back(boss.instantiate())
	Singleton.connect("boss_defeated", _on_boss_defeated)
	prepare_wheel()

func spawn_new_boss() -> void:
	wheel.hide_wheel()
	if nextBoss == null:
		nextBoss = remainingBosses.pick_random()
	remainingBosses.erase(nextBoss)
	Singleton.mainNode.add_child(nextBoss)
	nextBoss = null

func _on_next_boss_timer_timeout() -> void:
	spawn_new_boss()

func _on_boss_defeated():
	prepare_wheel()

func prepare_wheel():
	if remainingBosses.is_empty():
		Singleton.emit_signal("great_success")
	else:
		wheel.setup_wheel(remainingBosses)
		wheel.show_wheel()

func _on_wheel_of_unfortune_locked_in(boss: Enemy) -> void:
	nextBoss = boss
	$NextBossTimer.start()
