class_name BulletBurst
extends Resource

@export var bullet_type: String = "res://base/enemy_bullet.tscn"
@export var bullet_speed: float = 100
@export var bullet_inaccuracy: float = 0
@export var shot_inaccuracy: float = 0
@export var full_shot_spread: float = 0
@export var bullets_per_shot: int = 1
@export var shots_in_burst: int = 1
@export var time_between_shots: float = 0.1
@export var time_between_bursts: float = 1
@export var burst_count_limit: int = -1

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
#func _init(bullet_type = "res://base/enemy_bullet.tscn", \
	#bullet_speed = 100, \
	#bullet_inaccuracy = 5, \
	#shot_inaccuracy = 30, \
	#full_shot_spread = 30, \
	#bullets_per_shot = 2, \
	#shots_in_burst = 3, \
	#time_between_shots = 0.1, \
	#time_between_bursts = 1, \
	#burst_count_limit = -1, \
	#):
	#self.bullet_type = bullet_type
	#self.bullet_speed = bullet_speed
	#self.bullet_inaccuracy = bullet_inaccuracy
	#self.shot_inaccuracy = shot_inaccuracy
	#self.full_shot_spread = full_shot_spread
	#self.bullets_per_shot = bullets_per_shot
	#self.shots_in_burst = shots_in_burst
	#self.time_between_shots = time_between_shots
	#self.time_between_bursts = time_between_bursts
	#self.burst_count_limit = burst_count_limit
