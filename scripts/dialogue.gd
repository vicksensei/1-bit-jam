extends CanvasLayer
const TEXTSPEED = .04
var isActive:=false
var canExit:=false
@onready var TypeTimer = $Timer
@onready var content = %Content
@onready var continueMark = %ContinueMark
@onready var color_rect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.visible = false
	
	#TypeTimer = Timer.new()
	TypeTimer.wait_time = TEXTSPEED
	#TypeTimer.autostart = true
	TypeTimer.timeout.connect(onType)
	Signalbus.showText.connect(showText)
	#showText("This is a test")
	pass # Replace with function body.

func onType():
	if isActive:
		if content.visible_characters < content.text.length():
			content.visible_characters+=1
			Signalbus.playTypeSound.emit()
			#print(content.visible_characters)
		else:
			showFull()
func showFull():
	#TypeTimer.stop()
	continueMark.visible = true
	canExit = true
	#print("Full text shown")
func _process(delta):
	if Input.is_action_just_pressed("playeraction"):
		if canExit == false:
			showFull()
		else:
			color_rect.visible = false
			
			Global.currentState = Global.GameState.playing
			Signalbus.textFinished.emit()

func reset():
	color_rect.visible = true
	continueMark.visible = false
	canExit = false
	content.visible_characters = 0

func showText(text):
	Global.currentState = Global.GameState.paused
	reset()
	print( text)
	content.text = text
	isActive = true	
	pass
