extends Node2D
class_name camp_fire

@onready var warmth_radius = $"Warmth Radius"
@onready var flame_obj = $Flame
@onready var timer = $Timer

var isEmitting = true;
#var isNearPlayer = false;

func _ready():
	warmth_radius.body_entered.connect(_on_body_entered)
	warmth_radius.body_exited.connect(_on_body_exited)
	#timer.timeout.connect()
	pass

func _process(delta):		
	pass

#func _on_timeout_tick():
	#if flame_obj.isLit:
		#isEmitting = true
		#
	#if isNearPlayer and isEmitting:
		#Signalbus.updateWarmth.emit(1)
	#pass

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
