extends Node2D

@export var debugBunnies:=false

func _ready():
	Signalbus.saveBunnies.connect( updateDraw)

func updateDraw():
	await get_tree().create_timer(.1).timeout
	queue_redraw()

func _draw():
	drawBunnyPenDebug()

func drawBunnyPenDebug():
	if not debugBunnies: return
	var debug_data = Global.debug_data
	print(debug_data)
	if Global.debug_data:
		var polygon = debug_data["polygon"]
		var bounds = debug_data["bounds"]
		var pposition = debug_data["position"]
		
		draw_polyline(polygon, Color(0, 1, 0), 2)  # Draw polygon outline
		draw_rect(bounds, Color(1, 0, 0), false)  # Draw bounding box
		draw_circle(to_local(pposition), 10, Color(0, 0, 1))  # Draw the random point
