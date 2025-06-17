extends StaticBody2D
class_name Destroyable
@export var hp:int = 6

var direction = 1

func checkRadius(body):
	if body is Destroyable and not body == self:
		queue_free()
	

func getHit(body, dir):
	if body == self:
		print(name + " is hit! HP: "+ str(hp))
		TakeDamage()
		direction = dir

func Shake():
	print("Shake!")
	var aTime = .3
	var loops = 4
	var fTime = aTime/loops
	var tween = create_tween()
	tween.set_loops(loops)
	var initPos = position
	tween.tween_property(self, "position:x", initPos.x-1, fTime/3)
	tween.tween_property(self, "position:x", initPos.x+1, fTime/3)
	tween.tween_property(self, "position:x", initPos.x, fTime/3)
	
	#animation_player.play("Shake")

func TakeDamage():
	hp -= 1
	Shake()
