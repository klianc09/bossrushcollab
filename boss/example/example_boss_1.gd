extends Enemy

var movement = 100

enum Phase {
	INTRO, PHASE1, TRANSITION, PHASE2, OUTRO
}

var phase = Phase.INTRO

func _ready() -> void:
	super() # very important to call the base function (from the enemy script)
	invincible = true
	$CritArea.invincible = true
	# hardcoded position values not so nice, should use viewport size, 
	#  because viewport size might still change eventually
	#  but it will do for now
	position.x = 1200
	position.y = 300

func onHealthFullyLost() -> void:
	if phase == Phase.PHASE1:
		phase = Phase.TRANSITION
		hp = maxhp
		$Turret1.active = false
		$Turret2.active = false
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.RED, 0.5)
		tween.tween_property(self, "modulate", Color.WHITE, 0.5)
		tween.tween_property(self, "modulate", Color.RED, 0.5)
		tween.tween_property(self, "modulate", Color.WHITE, 0.5)
		$TransitionTimer.start()
	elif phase == Phase.PHASE2:
		phase = Phase.OUTRO
		$MainTurret.active = false
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_property(self, "modulate", Color.BLACK, 0.5)
		tween.tween_property(self, "scale", Vector2(0, 0), 1)
		$OutroTimer.start()


# Called every frame. 'delta' is the elapsed time in seconds since the previous frame.
func _process(delta: float) -> void:
	super(delta) # very important to call the base function (from the enemy script)
	
	if phase == Phase.INTRO:
		position.x -= delta * 200
		if position.x < 950:
			phase = Phase.PHASE1
			invincible = false
			$CritArea.invincible = false
			$Turret1.active = true
			$Turret2.active = true
	elif phase == Phase.PHASE1 or phase == Phase.PHASE2:
		position.y += delta * movement
		if position.y < 100:
			position.y = 100
			movement *= -1
		elif position.y > 500:
			position.y = 500
			movement *= -1

func _on_transition_timer_timeout() -> void:
	phase = Phase.PHASE2
	movement = 200
	$MainTurret.active = true

func _on_outro_timer_timeout() -> void:
	Singleton.bossFightOver()
	queue_free()
