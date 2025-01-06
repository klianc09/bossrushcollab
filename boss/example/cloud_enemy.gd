extends Enemy

func onHealthFullyLost():
	$DeathBullet.active = true # I'm honestly surprised this still manages to shoot before the enemy is getting deleted, but this is a pretty fragile way to do it
	Singleton.damageBoss(1)
	Singleton.screenshake(1)
	queue_free()
