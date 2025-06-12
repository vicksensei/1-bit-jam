extends StaticBody2D
class_name flame

@onready var animated_sprite_2d = $AnimatedSprite2D
var isLit = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
func checkLit():
	animated_sprite_2d.visible = isLit
		
func offsetSprite():
	animated_sprite_2d.position.y -= 6
	
func light():
	isLit = true
	checkLit()

func douse():
	isLit = false
	checkLit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
