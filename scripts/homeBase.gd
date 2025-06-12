extends Node2D
@onready var pen = $Pen
@onready var collision_shape_2d = $Pen/CollisionShape2D
@onready var pen_trigger = $penTrigger

func _ready():
	Global.pen = pen
	Global.penPoly= collision_shape_2d.polygon
	
	pen_trigger.body_entered.connect(SaveBunnies)

func SaveBunnies(body):
	if body is Player:
		Signalbus.saveBunnies.emit()
	pass
