extends CanvasLayer

@onready var Warmth = $Control/Bar/VBoxContainer/Warmth/ProgressBar
@onready var Stamina = $Control/Bar/VBoxContainer/Stamina/ProgressBar
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.updateStamina.connect(updateStamina)
	timer.timeout.connect(updateWarmth)
	#Signalbus.updateWarmth.connect(updateWarmth)
	Warmth.value = Global.playerTemp
	Stamina.value = Global.playerStamina
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateStamina(st):
	Global.playerStamina += st
	Global.playerStamina = clamp(Global.playerStamina,0,100)
	Stamina.value = Global.playerStamina
	if Global.playerStamina <=0:
		Signalbus.outOfStamina.emit()
		Global.log("Game Over!")
	
func updateWarmth():
	if Global.player.isWarm == true:
		Global.log("gaining Warmth")
		Global.playerTemp += 3
	else:
		if Global.playerTemp > 0:
			Global.log("losing Warmth")
			Global.playerTemp -= 1
		else:
			Global.log("losing Stamina")
			Signalbus.updateStamina.emit(-1)

	Global.playerTemp = clamp(Global.playerTemp,0,100)
	Warmth.value = Global.playerTemp
	
	
