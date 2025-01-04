extends Enemy

func _on_timer_timeout() -> void:
	var enemy = load("res://boss/example/cloud_enemy.tscn").instantiate()
	enemy.position = Vector2(randf_range(900, 1100), randf_range(0, 600))
	Singleton.mainNode.add_child(enemy)


func _on_timer_2_timeout() -> void:
	var enemy = load("res://boss/example/cloud_enemy.tscn").instantiate()
	enemy.position = Vector2(randf_range(900, 1100), randf_range(0, 600))
	enemy.maxhp = 8
	enemy.scale = Vector2(4, 4)
	Singleton.mainNode.add_child(enemy)

func onHealthFullyLost() -> void:
	Singleton.bossFightOver()
	# despawn all lingering enemies
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
	queue_free()
