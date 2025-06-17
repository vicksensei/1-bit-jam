extends Node2D
class_name camp_fire

@onready var warmth_radius = $"Warmth Radius"

var isEmitting = true;

func _ready():
	warmth_radius.body_entered.connect(_on_body_entered)
	warmth_radius.body_exited.connect(_on_body_exited)
	pass

func _process(delta):		
	pass
	
func _on_body_entered(body):
	if body is Player and isEmitting:
		#isNearPlayer = true
		body.isWarm = true
	pass
	
func _on_body_exited(body):
	if body is Player:
		#isNearPlayer = false
		body.isWarm = false
	pass
