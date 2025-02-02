extends Enemy

var attackPatterns = ["Slash", "Charge", "Stab"]
var secondPhase = false
var bigsaw

enum PHASE{
	INTRO, FIGHT, OUTRO
}
var phase = PHASE.INTRO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$AnimationPlayer.play("idle")
	Singleton.register_sfx("bounceSfx", $bounceSfx)
	var tween = get_tree().create_tween()
	var anchor = position
	position += Vector2(500, 0)
	invincible = true
	tween.tween_property(self, "position", anchor, 4)
	tween.tween_callback(startFight)

func startFight():
	invincible = false
	phase = PHASE.FIGHT
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if phase == PHASE.INTRO:
		Singleton.maintainScreenshake(3)
	elif phase == PHASE.OUTRO:
		Singleton.maintainScreenshake(6)

func damage(amount):
	super(amount)
	if not secondPhase and hp < maxhp / 2:
		secondPhase = true
		bigsaw = load("res://boss/crusher/saw_big.tscn").instantiate()
		bigsaw.position = global_position
		bigsaw.add_to_group("saw")
		get_parent().call_deferred("add_child", bigsaw) # because we are in the middle of a physics callback

func onHealthFullyLost():
	if phase == PHASE.FIGHT:
		phase = PHASE.OUTRO
		$Timer.stop()
		$AnimationPlayer.pause()
		invincible = true
		regularColor = Color.RED
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.RED, 3)
		tween.parallel().tween_property(bigsaw, "scale", Vector2(0, 0), 3)
		tween.tween_callback(despawn).set_delay(1)

func despawn():
	Singleton.screenshake(6)
	for enemy in get_tree().get_nodes_in_group("saw"):
		enemy.queue_free()
	Singleton.bossFightOver()
	queue_free()

func _on_timer_timeout() -> void:
	var attack = attackPatterns.pick_random()
	$AnimationPlayer.play(attack)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.play("idle")
	$Timer.start()
