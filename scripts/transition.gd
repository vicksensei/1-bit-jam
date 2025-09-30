extends CanvasLayer

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.fadein.connect(_fadeIn)
	Signalbus.fadeout.connect(_fadeOut)
	pass # Replace with function body.

func _fadeIn():
	animation_player.play("FadeIn")

func fadeInDone():
	Signalbus.fadeinDone.emit()
	
func _fadeOut():
	animation_player.play("FadeOut")

func fadeOutDone():
	Signalbus.fadeoutDone.emit()
	
