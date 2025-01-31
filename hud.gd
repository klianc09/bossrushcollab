extends Control


func _ready() -> void:
	Singleton.connect("boss_hp_changed", _on_boss_hp_changed)
	Singleton.connect("boss_defeated", _on_boss_defeated)
	Singleton.connect("boss_spawned", _on_boss_spawned)
	Singleton.connect("great_success", _on_great_success)


func _on_boss_spawned(boss: Enemy):
	$ApproachingLabel.visible = true
	$BossNameLabel.text = Singleton.bossNode.boss_name
	$BossNameLabel.visible = true
	var tween = get_tree().create_tween()
	tween.tween_callback(endOfSpawnSequence).set_delay(2)
	_on_boss_hp_changed(boss.hp) #also update the boss hp bar upon spawning
	var tween_hp = get_tree().create_tween()
	$BossHealthBar.value = 0
	tween_hp.tween_property($BossHealthBar, "value", $BossHealthBar.max_value, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func endOfSpawnSequence():
	$ApproachingLabel.visible = false
	$BossNameLabel.visible = false


func _on_boss_defeated():
	$SuccessLabel.visible = true
	var tween = get_tree().create_tween()
	tween.tween_callback(endOfDefeatSequence).set_delay(1)

func endOfDefeatSequence():
	$SuccessLabel.visible = false


func _on_great_success():
	$UltimateSuccessLabel.visible = true


func _on_boss_hp_changed(newHp: int) -> void:
	$BossHealthBar.max_value = Singleton.bossNode.maxhp
	$BossHealthBar.value = Singleton.bossNode.hp

func _on_player_charge_change(node: Player) -> void:
	$ChargeBar.max_value = node.maxCharge
	$ChargeBar.value = node.chargeTimer


func _on_player_health_change(node: Player) -> void:
	$PlayerHealthBar.max_value = node.maxHealth
	$PlayerHealthBar.value = node.health
	if node.health <= 0:
		$DeathLabel.visible = true
