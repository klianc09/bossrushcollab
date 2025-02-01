extends Control

var hp_highlight_color = Color.WHITE
var hit_duration = 0.5
var hit_delay = 0.0

func _ready() -> void:
	Singleton.connect("boss_hp_changed", _on_boss_hp_changed)
	Singleton.connect("boss_defeated", _on_boss_defeated)
	Singleton.connect("boss_spawned", _on_boss_spawned)
	Singleton.connect("great_success", _on_great_success)

func _process(delta: float) -> void:
	hit_delay -= delta
	# hp_highlight_color = hp_highlight_color.lerp(Color.WHITE, 0.05)
	if hit_delay < 0:
		$BossHealthBar1.value = $BossHealthBar2.value
	# $BossHealthBar.tint_progress = hp_highlight_color

func _on_boss_spawned(boss: Enemy):
	$TopStrip.visible = true
	$TopStrip.scale = Vector2(1, 0)
	$TopStrip2.visible = true
	$TopStrip2.scale = Vector2(1, 0)
	$TopStrip/ApproachingLabel.text = Singleton.bossNode.boss_name
	$TopStrip/ApproachingLabel.position = Vector2(996, 23)
	$TopStrip2/ApproachingLabel.text = "Boss Approaching"
	# workaround to force update the label size before the next frame: https://github.com/godotengine/godot/issues/7593
	var update = $TopStrip2/ApproachingLabel.size
	$TopStrip2/ApproachingLabel.size = update
	# end workaround
	$TopStrip2/ApproachingLabel.position = Vector2(-$TopStrip2/ApproachingLabel.size.x, 23)
	var textDuration = 3
	var tween = get_tree().create_tween()
	tween.tween_property($TopStrip, "scale", Vector2(1, 1), 0.15)
	tween.parallel().tween_property($TopStrip2, "scale", Vector2(1, 1), 0.15)
	tween.tween_property($TopStrip/ApproachingLabel, "position", Vector2(-$TopStrip/ApproachingLabel.size.x, 23), textDuration)
	tween.parallel().tween_property($TopStrip2/ApproachingLabel, "position", Vector2(996, 23), textDuration)
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
	$SuccessLabel.visible = true
	var tween = get_tree().create_tween()
	tween.tween_callback(endOfDefeatSequence).set_delay(1)

func endOfDefeatSequence():
	$SuccessLabel.visible = false


func _on_great_success():
	$UltimateSuccessLabel.visible = true


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
