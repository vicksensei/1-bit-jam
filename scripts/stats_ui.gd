extends CanvasLayer

@onready var Warmth = $Control/Bar/VBoxContainer/Warmth/ProgressBar
@onready var Stamina = $Control/Bar/VBoxContainer/Stamina/ProgressBar
@onready var timer = $Timer
@onready var bar = $Control/Bar

# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.updateStamina.connect(updateStamina)
	#Signalbus.showText.connect(hideUI)
	timer.timeout.connect(updateWarmth)
	#Signalbus.updateWarmth.connect(updateWarmth)
	Warmth.value = Global.playerTemp
	Stamina.value = Global.playerStamina
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateStamina(st):
	if Global.currentState == Global.GameState.playing:
		Global.playerStamina += st
		Global.playerStamina = clamp(Global.playerStamina,0,100)
		Stamina.value = Global.playerStamina
		if Global.playerStamina <=0:
			
			Signalbus.gameOver.emit()
			
			
func hideUI(text):
	bar.visible = false
	

func updateWarmth():
	if Global.currentState == Global.GameState.playing:
		bar.visible = true
		if Global.player.isWarm == true:
			Global.log("gaining Warmth")
			Global.playerTemp += 3
		else:
			if Global.playerTemp > 0:
				Global.log("losing Warmth")
				Global.playerTemp -= 10
			else:
				Global.log("losing Stamina")
				Signalbus.updateStamina.emit(-1)

		Global.playerTemp = clamp(Global.playerTemp,0,100)
		Warmth.value = Global.playerTemp
	else:
		hideUI(null)
	
