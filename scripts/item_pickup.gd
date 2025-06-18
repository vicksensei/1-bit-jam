extends Area2D	
class_name ItemPickup
@onready var item = $Item
@onready var animation_player = $AnimationPlayer
@onready var shadow = $Shadow

@export var iType: Global.itemType
const WOOD = 13
const STONE = 12
const COAL = 16
const CHERRY = 17

var target:CharacterBody2D = null
var spawnPos:Vector2
@export var isActive = false


func _ready():
	item.frame = getItemType()
	body_entered.connect(Pickup)
	animation_player.play("float")
	spawnPos = global_position
	#jump()
	pass # Replace with function body.

func Pickup(body):
	#print(body.name)
	if body is Player:
		#print("player entered")
		target = body

func getItemType():
	var tFrame = WOOD #default to wood
	match iType:
		Global.itemType.wood:
			tFrame = WOOD
		Global.itemType.stone:
			tFrame = STONE
		Global.itemType.coal:
			tFrame = COAL
		Global.itemType.food:
			tFrame = CHERRY					
	return tFrame

func Spawn(item_type:Global.itemType, item_pos:Vector2):
	iType = item_type
	item.frame = getItemType()
	isActive = false
	target= null
	global_position = item_pos
	shadow.visible = false
	
	jump()
		
	pass
	
func jump():
	var jumpHeight = 50
	var time = .6
	var tween =	create_tween()
	var randx = randi_range(-4,5) *10
	var	randy = randi_range(-1,1)*3
	var pos= global_position
	tween.set_ease(tween.EASE_OUT)
	tween.tween_property(self, "global_position:x", pos.x+ randx/2, time/2 )
	tween.parallel().tween_property(self, "global_position:y", pos.y+ randx/2 -jumpHeight,time/2  )
	
	tween.set_ease(tween.EASE_IN)
	tween.tween_property(self, "global_position:x", pos.x+ randx,time/2  )
	tween.parallel().tween_property(self, "global_position:y", pos.y+ randy,time/2  )

	tween.tween_callback(enableShadow)

func enableShadow():
	spawnPos = global_position
	shadow.visible = true
	animation_player.play("float")
func _physics_process(delta):
	
	if Global.currentState == Global.GameState.playing:
		var direction
		if isActive and not target == null:
			direction = global_position.move_toward( target.global_position,3)
			global_position = direction
			if global_position.distance_to(target.global_position) <.1:
				Signalbus.itemPickup.emit(iType)
				queue_free()
		else:
			if global_position.distance_to(spawnPos) > .1:
				direction =global_position.move_toward( spawnPos,3)
				global_position = direction
			elif not isActive:
				isActive = true
				shadow.visible = true 
						
	pass
