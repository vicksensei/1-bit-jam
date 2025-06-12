extends Area2D

var sprite:Sprite2D
func _ready():
	print(name + "is ready")
	body_entered.connect(checkBody)
	body_exited.connect(resetBody)

func _process(delta):
	pass

func checkBody(body):
	print(body.name +" entered "+ name)
	if body is Destroyable:
		Signalbus.facingTree.emit(body)
	elif body is flame:
		Signalbus.facingFlame.emit(body)
	pass
func resetBody(body):
	if body is Destroyable or body is flame:
		Signalbus.clearFacing.emit()
	pass
