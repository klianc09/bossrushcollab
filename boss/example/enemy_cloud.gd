extends Enemy

func _on_timer_timeout() -> void:
	var enemy = load("res://boss/example/cloud_enemy.tscn").instantiate()
	var screenWidth = Singleton.viewportSize.x
	enemy.position = Vector2(randf_range(screenWidth - 200, screenWidth), randf_range(0, Singleton.viewportSize.y))
	enemy.add_to_group("cloud")
	Singleton.mainNode.add_child(enemy)


func _on_timer_2_timeout() -> void:
	var enemy = load("res://boss/example/cloud_enemy.tscn").instantiate()
	var screenWidth = Singleton.viewportSize.x
	enemy.position = Vector2(randf_range(screenWidth - 200, screenWidth), randf_range(0, Singleton.viewportSize.y))
	enemy.maxhp = 8
	enemy.scale = Vector2(4, 4)
	enemy.add_to_group("cloud")
	Singleton.mainNode.add_child(enemy)

func onHealthFullyLost() -> void:
	Singleton.bossFightOver()
	# despawn all lingering spawned enemies
	for enemy in get_tree().get_nodes_in_group("cloud"):
		enemy.queue_free()
	queue_free()
