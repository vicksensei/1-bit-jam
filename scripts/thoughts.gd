extends Sprite2D
@onready var player = $".."
@onready var thoughts = $"."

func _ready():
	hideThoughts()
	Signalbus.facingTree.connect(showAction)
	Signalbus.clearFacing.connect(hideThoughts)
	Signalbus.updateStamina.connect(chooseFrame)
func hideThoughts():
	visible = false

func showAction(body):
	if body is Destroyable:
		chooseFrame(1)
		visible = true

func chooseFrame(s):
	await get_tree().process_frame
	if Global.playerStamina > 5:
		frame = 5
	else:
		frame = 3
