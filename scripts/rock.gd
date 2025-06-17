extends Destroyable

@onready var duplicate_protection = $DuplicateProtection

# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.hitTree.connect(getHit)
	duplicate_protection.body_entered.connect(checkRadius)
	pass # Replace with function body.


func TakeDamage():
	super()
	if hp == 0:
		Signalbus.spawnRock.emit(global_position)
		queue_free()
