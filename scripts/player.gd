extends CharacterBody2D
class_name Player

@onready var animation_player = $AnimationPlayer
@onready var run_timer = $RunTimer

const SPEED = 100.0
var animation_direction:String= "down"
var animation_type:String = "idle"
var animation_name:String 
var canUseTool:bool = false
var dash = 50.0
var isDashing = false
var isWarm = false
var currentActionTarget

enum playerState{
	walking,
	paused,
	action,
}
var currentPlayerState:playerState = playerState.walking

var followers :Array = []


func  _ready():
	Global.player = $"."
	Signalbus.facingTree.connect(enableChop)
	Signalbus.clearFacing.connect(disableChop)
	run_timer.timeout.connect(tickStamina)


func _physics_process(_delta):
	if Global.currentState == Global.GameState.playing:
		if currentPlayerState == playerState.walking and canUseTool:
			if Input.is_action_just_pressed("playeraction"):
				if Global.playerStamina > 5:
					Signalbus.updateStamina.emit(-5)
					print("Action!")
					currentPlayerState = playerState.action
					var dir = -1
					if currentActionTarget.global_position.x > global_position.x:
						dir = 1 
					Signalbus.hitTree.emit(currentActionTarget, dir)
					await get_tree().create_timer(.3).timeout
					currentPlayerState = playerState.walking
				else:
					print("Out of Stamina!")

		if Input.is_action_just_pressed("playereat"):
			print("food:" + str(Global.items.food))
			if Global.items.food > 0:
				Global.items.food = Global.items.food -1
				Signalbus.updateStamina.emit(50)
		
		var movement_direction:= Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")		
		).normalized()	
		
		if Input.is_action_pressed("playerdash") and Global.playerStamina > 5:
			velocity = movement_direction * (SPEED + dash)
			isDashing = true
		else:
			velocity = movement_direction * SPEED
			isDashing = false
	
		if Input.is_action_pressed("move_up"): 
			animation_direction = "up"
			Signalbus.directionChange.emit(animation_direction)
		if Input.is_action_pressed("move_down"): 
			animation_direction = "down"
			Signalbus.directionChange.emit(animation_direction)
		if Input.is_action_pressed("move_left"): 
			animation_direction = "left"
			Signalbus.directionChange.emit(animation_direction)
		if Input.is_action_pressed("move_right"): 
			animation_direction = "right"
			Signalbus.directionChange. emit(animation_direction)
		
		if Input.is_action_just_pressed("playerbuild"):
			Signalbus.buildFire.emit(animation_direction)
			pass
		
		if not velocity == Vector2.ZERO: animation_type = "walk"
		else: animation_type =  "idle"
		animation_name = animation_type + "_" + animation_direction
		animation_player.play(animation_name)
		if currentPlayerState == playerState.walking:
			move_and_slide()
		elif currentPlayerState == playerState.action:
			pass
func tickStamina():
	if isDashing:
		Signalbus.updateStamina.emit(-1)
		
	pass
func enableChop(body):
	currentActionTarget = body
	canUseTool = true;

func disableChop():
	currentActionTarget = null
	canUseTool = false;
