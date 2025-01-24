extends Bullet

func despawn(timeout: bool):
	var smoketrail = $smoketrail
	# very important: first reparent THEN change emitting property:
	# https://www.reddit.com/r/godot/comments/14w5g15/comment/jrgjpde/
	smoketrail.reparent(get_parent())
	smoketrail.emitting = false
	super(timeout)
