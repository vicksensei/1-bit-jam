extends CharacterBody2D
class_name Bunny

@onready var animation_player = $AnimationPlayer
@onready var bunny_wabbit = $BunnyWabbit
@onready var followScript:follow = $Follow

@onready var detection_range = $DetectionRange

@export var isFound = false
@export var isRescued = false

func _ready():
	detection_range.body_entered.connect(Find)	
	Signalbus.saveBunnies.connect(goToPen)

func Find(body):
	if body is Player and not isRescued and not isFound:
		var player:Player = body
		isFound = true
		followScript.isFollowing = true
		var numFol = player.followers.size()
		if numFol > 0:
			followScript.target = player.followers[numFol-1]
		player.followers.append(self)		
	pass

func _physics_process(delta):
	if isFound and not isRescued:
		if not velocity == Vector2.ZERO:
			animation_player.play("hop")
		else:
			animation_player.play("idle")
	elif isFound and isRescued:
		animation_player.play("sleep")
	else:
		animation_player.play("shiver")
	if velocity.x >0:
		bunny_wabbit.flip_h = true		
	elif velocity.x <0:
		bunny_wabbit.flip_h = false
	pass

func goToPen():
	var point = Global.get_random_point_in_polygon(Global.pen, Global.penPoly)
	if isFound and followScript.isFollowing and not isRescued:
		var new_target = CharacterBody2D.new()  # Create an empty Node2D
		new_target.global_position = point  # Set position
		print(point)
		add_child(new_target)  # Add it to the scene
		followScript.target = new_target
		followScript.followDist = 5
		await followScript.arrived
		followScript.isFollowing = false
		followScript.target = null
		new_target.queue_free()
		isRescued = true
		Global.addItem(Global.itemType.bunnies)
	pass
