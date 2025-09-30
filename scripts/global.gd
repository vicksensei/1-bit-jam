extends Node

var debugMode := false

var houseBuilt = false
var bunniesFound = false

enum GameState{
	starting,
	paused,
	playing,
	
}

enum itemType{
	wood,
	stone,
	food,
	bunnies,
	coal,
}
var player:Player
var world:WorldController
var currentState: GameState = GameState.starting

var currentLevel
var currentItemLayer

var playerStamina = 100
var playerTemp = 100
var mainscene


var items ={
	"wood": 10,
	"stone": 10,
	"coal": 0,
	"food": 0,
	"bunnies": 0,
}

func _ready():
	currentState = GameState.starting

func getItemCount(item:itemType) -> int:
	match item:
		itemType.wood:
			return items.wood
		itemType.stone:
			return items.stone
		itemType.food:
			return items.food
		# itemType.coal:
		# 	return items.coal
		itemType.bunnies:
			return items.bunnies
	# Default case if item type is not recognized
	return 0

func useItem(item:itemType, amount:int):
	match item:
		itemType.wood:
			if items.wood < amount:
				Global.log("Not enough wood to use")
				return
			if amount <= 0:
				Global.log("Invalid amount to use")
				return
			if amount > items.wood:
				Global.log("Using more wood than available")
				return
			items.wood -= amount
			Global.log("Used wood: " + str(amount))
		itemType.stone:
			if items.stone < amount:
				Global.log("Not enough stone to use")
				return
			if amount <= 0:
				Global.log("Invalid amount to use")
				return
			if amount > items.stone:
				Global.log("Using more stone than available")
				return
			Global.log("Used stone: " + str(amount))
			items.stone -= amount
		itemType.food:
			if items.food < amount:
				Global.log("Not enough food to use")
				return
			if amount <= 0:
				Global.log("Invalid amount to use")
				return
			if amount > items.food:
				Global.log("Using more food than available")
				return
			Global.log("Used food: " + str(amount))
			items.food -= amount
		# itemType.coal:
		# 	items.coal -= amount
		# itemType.bunnies:
		# 	items.bunnies -= amount
	Signalbus.itemAdded.emit()
	
func addItem(item:itemType):
	match item:
		itemType.wood:
			items.wood +=1
		itemType.stone:
			items.stone +=1
		itemType.food:
			items.food +=1
		# itemType.coal:
		# 	items.coal +=1
		itemType.bunnies:
			items.bunnies +=1
	Signalbus.itemAdded.emit()

var debug_data = {
"polygon": [],
"bounds": Rect2(),
"random_point": Vector2.ZERO,
"local_point": Vector2.ZERO,
"position" : Vector2.ZERO
}
var pen:Area2D
var penPoly: PackedVector2Array

func log(text):
	if debugMode == true:
		print(text)

func get_random_point_in_polygon(area:Area2D, polygon: PackedVector2Array) -> Vector2:
	if polygon.is_empty():
		return Vector2.ZERO
		
	var bounds = Rect2(polygon[0], Vector2.ZERO)
	for point in polygon:
		bounds = bounds.expand(point)
	
	while true:
		var random_point = Vector2(
			randf_range(bounds.position.x, bounds.end.x),
			randf_range(bounds.position.y, bounds.end.y))
		var local_point = random_point - bounds.position
		if Geometry2D.is_point_in_polygon(local_point, polygon):
			debug_data = {
				"polygon": polygon,
				"bounds":bounds,
				"random_point": random_point,
				"local_point":local_point,
				"position": area.global_position + local_point
			}
			return area.global_position + local_point
	return  Vector2.ZERO

func GameOver():
	currentState = GameState.paused
	Signalbus.outOfStamina.emit()
	Signalbus.fadeout.emit()
	await Signalbus.fadeoutDone
	Signalbus.showText.emit("... Looks like this is the end for me...")
	await Signalbus.textFinished
	Signalbus.showText.emit("... I hope my animal friends will survive without me...")
	await Signalbus.textFinished
	
	
	

var chunk_data:Dictionary={
  "background": {
	"snow": { "weight": 0.8, "allowed_neighbors": ["snow", "ice"] },
	"ice": { "weight": 0.2,"allowed_neighbors": ["snow", "ice"], "influences_neighbors": true }
  },
  "foreground": {
	"tree": { "spawn_on": "snow", "min_distance": 3, "chance": 0.3 },
	"stone": { "spawn_on": "snow", "min_distance": 2, "chance": 0.2 }
  }
}
