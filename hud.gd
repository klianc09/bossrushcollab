extends Control

var hp_highlight_color = Color.BLACK
var hit_duration = 0.5
var hit_delay = 0.0

func _ready() -> void:
	Singleton.connect("boss_hp_changed", _on_boss_hp_changed)
	Singleton.connect("boss_defeated", _on_boss_defeated)
	Singleton.connect("boss_spawned", _on_boss_spawned)
	Singleton.connect("great_success", _on_great_success)

func _process(delta: float) -> void:
	hit_delay -= delta
	hp_highlight_color = hp_highlight_color.lerp(Color.BLACK, 0.05)
	if hit_delay < 0:
		$BossHealthBar1.value = $BossHealthBar2.value
	$BossHealthBar1.tint_progress = hp_highlight_color

func _on_boss_spawned(boss: Enemy):
	$"../../music".stop()
	$"../../warningSfx".play()
	$Instructions.visible = false
	var labelypos = 18
	$TopStrip.visible = true
	$TopStrip.scale = Vector2(1, 0)
	$TopStrip2.visible = true
	$TopStrip2.scale = Vector2(1, 0)
	$TopStrip/ApproachingLabel.text = Singleton.bossNode.boss_name
	$TopStrip/ApproachingLabel.position = Vector2(996, labelypos)
	$TopStrip2/ApproachingLabel.text = "Boss Approaching"
	# workaround to force update the label size before the next frame: https://github.com/godotengine/godot/issues/7593
	var update = $TopStrip2/ApproachingLabel.size
	$TopStrip2/ApproachingLabel.size = update
	# end workaround
	$TopStrip2/ApproachingLabel.position = Vector2(-$TopStrip2/ApproachingLabel.size.x, labelypos)
	var textDuration = 3
	var tween = get_tree().create_tween()
	tween.tween_property($TopStrip, "scale", Vector2(1, 1), 0.15)
	tween.parallel().tween_property($TopStrip2, "scale", Vector2(1, 1), 0.15)
	tween.tween_property($TopStrip/ApproachingLabel, "position", Vector2(-$TopStrip/ApproachingLabel.size.x, labelypos), textDuration)
	tween.parallel().tween_property($TopStrip2/ApproachingLabel, "position", Vector2(996, labelypos), textDuration)
	tween.tween_property($TopStrip, "scale", Vector2(1, 0), 0.15)
	tween.parallel().tween_property($TopStrip2, "scale", Vector2(1, 0), 0.15)
	tween.tween_callback(endOfSpawnSequence).set_delay(2)
	
	_on_boss_hp_changed(boss.hp) #also update the boss hp bar upon spawning
	$BossHealthBar1.value = 0
	$BossHealthBar2.value = 0
	var tween_hp = get_tree().create_tween()
	tween_hp.tween_property($BossHealthBar2, "value", $BossHealthBar2.max_value, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func endOfSpawnSequence():
	pass


func _on_boss_defeated():
	$"../../music".play()
	$SuccessLabel.text = "You defeated:\n" + Singleton.bossNode.boss_name + "!"
	$SuccessLabel.visible = true
	var tween = get_tree().create_tween()
	tween.tween_callback(endOfDefeatSequence).set_delay(1)

func endOfDefeatSequence():
	$SuccessLabel.visible = false


func _on_great_success():
	var player : Player = $"../../player"
	$UltimateSuccessLabel.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property($TheLight, "modulate", Color.WHITE, 4)
	tween.parallel().tween_method(set_sfx_volume, 0, -70, 4)
	var anchor = $UltimateSuccessLabel.position
	$UltimateSuccessLabel.position = Vector2(anchor.x, Singleton.viewportSize.y)
	tween.tween_property($UltimateSuccessLabel, "position", anchor, 20)
	tween.tween_callback(showFinalScore)
	$FinalScore.text = "Time: " + str(int(player.totalTime)) + "s \n Hits: " + str(player.hitsTaken)

func showFinalScore():
	$FinalScore.visible = true

func set_sfx_volume(volume_db):
	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus, volume_db)

func _on_boss_hp_changed(newHp: int) -> void:
	$BossHealthBar1.max_value = Singleton.bossNode.maxhp
	$BossHealthBar2.max_value = Singleton.bossNode.maxhp
	$BossHealthBar2.value = Singleton.bossNode.hp
	hp_highlight_color = Color(10, 5, 5)
	hit_delay = hit_duration

func _on_player_charge_change(node: Player) -> void:
	$ChargeBar.max_value = node.maxCharge
	$ChargeBar.value = node.chargeTimer


func _on_player_health_change(node: Player) -> void:
	$PlayerHealthBar.max_value = node.maxHealth
	$PlayerHealthBar.value = node.health
	if node.health <= 0:
		$DeathLabel.visible = true
