extends Node2D
@onready var pen = $Pen
@onready var collision_shape_2d = $Pen/CollisionShape2D
@onready var pen_trigger = $penTrigger
@onready var basemap = $Basemap
@onready var warmth_radius = $"Indoors/Warmth Radius"

func _ready():
	Global.pen = pen
	Global.penPoly= collision_shape_2d.polygon
	Signalbus.houseBuilt.connect(enableMap)
	pen_trigger.body_entered.connect(SaveBunnies)
	visible = false
	basemap.collision_enabled = false
	warmth_radius.monitoring = false
func SaveBunnies(body):
	if body is Player and Global.houseBuilt == true:
		Signalbus.saveBunnies.emit()
	pass

func enableMap():
	Global.houseBuilt = true
	visible = true
	basemap.collision_enabled = true
	warmth_radius.monitoring = true
	pass
