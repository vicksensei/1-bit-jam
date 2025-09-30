extends Node

@onready var game = $".."

const CONTENT = preload("res://scenes/content.tscn")
const LOGO_SPLASH = preload("res://logoSplash/logo_splash.tscn")
const TITLE_SCREEN = preload("res://scenes/title_screen.tscn")

var title
var content
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentState = Global.GameState.starting
	
	var splash = LOGO_SPLASH.instantiate()
	title = TITLE_SCREEN.instantiate()
	content = CONTENT.instantiate()
	
	Signalbus.startNewGame.connect(startNew)
	await get_tree().create_timer(.5).timeout
	if Global.debugMode == true:
		add_child(content)
	else:
		Signalbus.toggleReplace.emit(false)
		add_child(splash)
	
	#game.add_child(splash)
		await get_tree().create_timer(3).timeout
		killScenes()
		Signalbus.toggleReplace.emit(true)
		add_child(title)

func killScenes():
	for child in get_children():
		child.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func backToTitle():
	killScenes()
	add_child(title)
	Signalbus.fadein.emit()
	Global.currentState = Global.GameState.starting

func startNew():
	content = CONTENT.instantiate()
	Signalbus.fadeout.emit()
	await Signalbus.fadeoutDone
	killScenes()
	print("Fade out done")
	Signalbus.showText.emit("There was a very bad storm... I lost everything.")
	await Signalbus.textFinished
	Global.log("text finished 1")
	Signalbus.showText.emit("I need to gather wood and stone to rebuild")
	await Signalbus.textFinished
	Global.log("text finished 2")
	add_child(content)
	Signalbus.fadein.emit()
	await Signalbus.fadeinDone
	Global.currentState = Global.GameState.playing
	
