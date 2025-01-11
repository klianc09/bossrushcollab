extends Node2D

## Whether this turret is active or not. Will not shoot or reload when inactive.
@export var active : bool = true
## The burstdata defining the bullet pattern.
@export var burst_data : BulletBurst
var shot_count : int = 0
var burst_count : int = 0
var shot_timer : float = 0
var burst_timer : float = 0

## The direction this turret is shooting in.
@export var aim_direction : Vector2 = Vector2(-1, 0)
## Whether the turret should automatically aim towards the player at the start of a burst.
@export var player_aimed : bool = false
## The amount of degrees this turret should rotate after every shot.
@export var rotation_each_shot : float = 0
## The distance away from the center that bullets should spawn.
@export var bullet_spawn_offset : float = 0

func reset() -> void:
	shot_count = 0
	burst_count = 0
	shot_timer = 0
	burst_timer = 0

func _process(delta: float) -> void:
	if active:
		if burst_data.burst_count_limit > -1 and burst_count >= burst_data.burst_count_limit:
			return
		if shot_count < burst_data.shots_in_burst:
			shot_timer -= delta
			if shot_timer <= 0:
				if shot_count == 0:
					if player_aimed:
						var player = get_tree().get_nodes_in_group("player").pop_front()
						aim_direction = player.global_position - global_position
						if aim_direction.is_zero_approx():
							aim_direction = Vector2(-1, 0)
				shoot()
				aim_direction = aim_direction.rotated(deg_to_rad(rotation_each_shot))
				shot_count += 1
				shot_timer = burst_data.time_between_shots
				burst_timer = burst_data.time_between_bursts
		else:
			burst_timer -= delta
			if burst_timer <= 0:
				burst_count += 1
				shot_timer = 0
				shot_count = 0

func shoot() -> void:
	var bulletScene : PackedScene = load(burst_data.bullet_type)
	var spreadOffset = -burst_data.full_shot_spread / 2
	var spreadStep = 0
	if burst_data.bullets_per_shot > 1:
		if burst_data.full_shot_spread == 360:
			# if spread is 360 degrees, make sure the first and final bullet don't go in the identical direction
			spreadStep = burst_data.full_shot_spread / burst_data.bullets_per_shot
		else:
			spreadStep = burst_data.full_shot_spread / (burst_data.bullets_per_shot - 1)
	var shot_direction = aim_direction.rotated(global_rotation + deg_to_rad(randf_range(-burst_data.shot_inaccuracy, burst_data.shot_inaccuracy)))
	for i in range(burst_data.bullets_per_shot):
		var bullet = bulletScene.instantiate()
		var actual_direction = shot_direction.rotated(deg_to_rad(randf_range(-burst_data.bullet_inaccuracy, burst_data.bullet_inaccuracy) + spreadOffset + spreadStep * i))
		bullet.position = global_position + actual_direction.normalized() * bullet_spawn_offset
		bullet.bulletSpeed = burst_data.bullet_speed
		bullet.rotation = actual_direction.angle() + PI # We assume that left (negative x-axis) is the canonical "forward" direction of bullet scenes
		Singleton.mainNode.add_child(bullet)
	var particle = Singleton.createParticle("res://base/particle.tscn")
	particle.position = global_position
