extends TileMapLayer

@export var prefabs: Array[PackedScene]

@onready var treeObj = {
	"objName":"tree",
	"atlas_coord": Vector2i(1,1),
	"prefab": prefabs[0]
}

@onready var stoneObj = {
	"objName":"stone",
	"atlas_coord": Vector2i(0,1),
	"prefab": prefabs[1]
}

@onready var flameObj = {
	"objName":"flame",
	"atlas_coord": Vector2i(2,1),
	"prefab": prefabs[2]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(.05).timeout
	checkMap()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func checkMap():
	var cells = get_used_cells()
	for coord in cells:
		var cell = get_cell_atlas_coords(coord)
		print(cell)
		if cell == treeObj.atlas_coord:
			spawn(coord, treeObj)
			#print("Spawned " +treeObj.objName +" at " + str(coord))
		if cell == stoneObj.atlas_coord:
			spawn(coord, stoneObj )
			#print("Spawned " +stoneObj.objName +" at " + str(coord))
		if cell == flameObj.atlas_coord:
			spawn(coord, flameObj, true )
		if cell == Vector2i(2,3):			
			spawn(coord, flameObj, false )
	pass
	
func spawn(pos:Vector2i, object, offset = false):
	var parent = get_parent()
	var prefab = object.prefab
	var obj = prefab.instantiate()
	parent.add_child(obj)
	var localPos = map_to_local(pos)
	obj.global_position =  to_global(localPos)
	if offset == true:
		obj.offsetSprite()
	pass	
	
