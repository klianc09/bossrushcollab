class_name BulletBurst
extends Resource

## The scene file that represents the bullet to spawn
@export_file("*.tscn") var bullet_type: String = "res://base/enemy_bullet.tscn"
## The default speed the bullet spawns with
@export var bullet_speed: float = 100
## The random angle added to any individual bullet's direction
@export_range(0, 360, 0.1, "suffix:°") var bullet_inaccuracy: float = 0
## The random angle added to a full shot (if there are multiple bullets in a shot, this will keep them evenly spaced, but their general direction to change)
@export_range(0, 360, 0.1, "suffix:°") var shot_inaccuracy: float = 0
## The full angle range across which bullets are evenly spaced
@export_range(0, 360, 0.1, "suffix:°") var full_shot_spread: float = 0
## The number of bullets per shot (spawn at the same time)
@export var bullets_per_shot: int = 1
## The number of shots in a burst (spawn with a delay)
@export var shots_in_burst: int = 1
## The time between shots [seconds]
@export var time_between_shots: float = 0.1
## The time between bursts [seconds]
@export var time_between_bursts: float = 1
## The number of bursts this will shoot before stopping (keep at -1 for no limit)
@export var burst_count_limit: int = -1
