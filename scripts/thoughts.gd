extends Sprite2D
@onready var player = $".."
@onready var thoughts = $"."

func _ready():
	hideThoughts()
	Signalbus.facingTree.connect(showAction)
	Signalbus.clearFacing.connect(hideThoughts)

func hideThoughts():
	visible = false

func showAction(body):
	if body is Destroyable:
		if Global.playerStamina > 0:
			frame = 5
		else:
			frame = 3
		visible = true
