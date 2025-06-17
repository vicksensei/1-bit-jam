extends camp_fire
class_name  interior

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	warmth_radius.body_entered.connect(goIndoors)
	warmth_radius.body_exited.connect(goOutdoors)
	pass # Replace with function body.
func goIndoors(body):
	if body is Player:
		Signalbus.goIndoors.emit()
	pass
func goOutdoors(body):
	if body is Player:
		Signalbus.goOutdoors.emit()
	pass
