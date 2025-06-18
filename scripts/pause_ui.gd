extends CanvasLayer

@onready var settings = $Bar/VBoxContainer/Settings
@onready var exit = $Bar/VBoxContainer/Exit
@onready var colors = $Bar/VBoxContainer/Colors

@onready var bar = $Bar


# Called when the node enters the scene tree for the first time.
func _ready():
	settings.pressed.connect(onSettings)
	exit.pressed.connect(onExit)
	colors.pressed.connect(onColor)
	Signalbus.pause.connect(onPause)
	bar.visible = false

func onPause():
	if Global.currentState == Global.GameState.playing:
		Global.log("Pause")
		Global.currentState = Global.GameState.paused
		bar.visible= true
	else:
		onExit()
func onColor():
	Signalbus.showColors.emit()
	
func onExit():
	if Global.currentState == Global.GameState.paused:
		Global.log("Unpause")
		Global.currentState = Global.GameState.playing
		bar.visible= false
	pass

func onSettings():
	pass
