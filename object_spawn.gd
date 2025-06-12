extends Node

@export var itemPrefab:PackedScene
#@export var rock:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.spawnWood.connect(SpawnWood)
	Signalbus.spawnRock.connect(SpawnRock)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func SpawnWood(pos:Vector2):	
	SpawnItem("wood", pos, 3, 4)	


func SpawnRock(pos:Vector2):	
	SpawnItem("rock", pos, 3, 4)
	
func SpawnItem(item, pos, min, max):
	var rand = randi_range(min,max)
	for num in range(0,rand):
		var i:ItemPickup = itemPrefab.instantiate()
		add_child(i)
		var roll = randf()
		match item:
			"rock":
				if roll< .25: i.Spawn(Global.itemType.coal, pos)	
				else: 	i.Spawn(Global.itemType.stone, pos)	
			"wood": 
				if roll< .25: i.Spawn(Global.itemType.food, pos)	
				else: i.Spawn(Global.itemType.wood, pos)	
		
	
