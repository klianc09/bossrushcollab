extends Enemy
signal dead
func onHealthFullyLost() -> void:
	
	dead.emit()
	$"../wallBreak".play()
	super()
func damage(amount: float) -> void:
	super(amount)
	$"../wallHit".play()
	
