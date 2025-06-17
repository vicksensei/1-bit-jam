extends Node

var debugMode := false

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

var items ={
	"wood": 0,
	"stone": 0,
	"coal": 0,
	"food": 0,
	"bunnies": 0,
}

func _ready():
	currentState = GameState.playing
	
func addItem(item:itemType):
	match item:
		itemType.wood:
			items.wood +=1
		itemType.stone:
			items.stone +=1
		itemType.food:
			items.food +=1
		itemType.coal:
			items.coal +=1
		itemType.bunnies:
			items.wood +=1
			

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
