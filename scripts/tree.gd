extends Destroyable
class_name tree
@onready var animation_player = $AnimationPlayer
@onready var top = $Top
@onready var duplicate_protection = $DuplicateProtection

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = 6
	Signalbus.hitTree.connect(getHit)
	duplicate_protection.body_entered.connect(checkRadius)
	pass # Replace with function body.

func Fall():
	fallAnim()
	#animation_player.play("Fall")

func fallAnim():	
	print("Fall!")
	var aTime = .7
	var tween = create_tween()
	var initPos = position
	tween.tween_property(top, "position:x", 8 * direction, .7)
	
	tween.parallel().tween_property(top, "rotation_degrees", 5 * direction, .15)
	tween.chain().tween_property(top, "rotation_degrees", 90  * direction, .55)
	tween.finished.connect(DestroyTop)
	pass	

func TakeDamage():
	super()
	if hp == 3:
		Fall()
	elif hp == 0:
		Signalbus.spawnWood.emit(global_position)
		queue_free()
		
func DestroyTop():
	top.visible= false
	Signalbus.spawnWood.emit(global_position)
	pass
