extends Node2D
@onready var right_action = $RightAction
@onready var left_action = $LeftAction
@onready var up_action = $UpAction
@onready var down_action = $DownAction

var currentDir = ""

func _ready():
	Signalbus.directionChange.connect(checkDirection)
	disableAll()
	pass # Replace with function body.


func _process(delta):
	pass

func checkDirection(d):
	if not currentDir == d:
		currentDir = d
		disableAll()
		match currentDir:
			"right":
				right_action.monitoring = true
			"left":
				left_action.monitoring = true
			"up":
				up_action.monitoring = true
			"down":
				down_action.monitoring = true
	pass
func disableAll():
	right_action.monitoring = false
	left_action.monitoring = false
	up_action.monitoring = false
	down_action.monitoring = false
	pass
	
