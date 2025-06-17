extends Node2D
@onready var snow = $Snow


# Called when the node enters the scene tree for the first time.
func _ready():
	
	Signalbus.goIndoors.connect(hideSnow)
	Signalbus.goOutdoors.connect(showSnow)
	pass # Replace with function body.

func showSnow():
	snow.visible = true
	
func hideSnow():
	snow.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
