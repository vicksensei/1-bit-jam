extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("scroll_up"):
		zoom +=Vector2(.1,.1)
		zoom = clamp(zoom, Vector2(0.5,0.5), Vector2(3,3))
	if Input.is_action_just_pressed("scroll_down"):
		zoom -=Vector2(.1,.1)
		zoom =clamp(zoom, Vector2(0.5,0.5), Vector2(3,3))
	pass
