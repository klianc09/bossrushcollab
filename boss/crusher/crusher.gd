extends Enemy

var attackPatterns = ["Slash", "Charge", "Stab"]
var secondPhase = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$AnimationPlayer.play("idle")
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func damage(amount):
	super(amount)
	if not secondPhase and hp < maxhp / 2:
		secondPhase = true
		var bigsaw = load("res://boss/crusher/saw_big.tscn").instantiate()
		bigsaw.position = global_position
		bigsaw.add_to_group("saw")
		get_parent().call_deferred("add_child", bigsaw) # because we are in the middle of a physics callback

func onHealthFullyLost():
	for enemy in get_tree().get_nodes_in_group("saw"):
		enemy.queue_free()
	super()

func _on_timer_timeout() -> void:
	var attack = attackPatterns.pick_random()
	$AnimationPlayer.play(attack)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.play("idle")
	$Timer.start()
