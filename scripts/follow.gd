extends Node
class_name follow
var speed
@export var target:CharacterBody2D
var isFollowing = false
var parent:CharacterBody2D
var followDist = 20
signal arrived
func _ready():
	parent = get_parent()
	speed = 100.0
	target = Global.player
	
func _physics_process(delta):
	if isFollowing:
		if not target == null:
			var direction= (target.position - parent.position).normalized()
			if target.position.distance_to(parent.position) <= followDist:
				direction = Vector2.ZERO
				if not target == Global.player:
					arrived.emit()
			parent.velocity = direction * speed
			parent.move_and_slide()
		else:
			target = Global.player
