extends TileMapLayer
class_name Foreground

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

@onready var campFireObj = {
	"objName":"campFire",
	"atlas_coord": Vector2i(2,1),
	"prefab": prefabs[3]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.buildFire.connect(buildFire)
	#await get_tree().create_timer(.05).timeout
	#checkMap()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func checkMap():
	var cells = get_used_cells()
	for coord in cells:
		checkCell(coord)
	pass

func checkCell(coord):
	var cell = get_cell_atlas_coords(coord)
	Global.log(cell)
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

func buildFire(dname):
	print("build fire "+dname)
	var stone = Global.getItemCount(Global.itemType.stone)
	var wood = Global.getItemCount(Global.itemType.wood)
	if stone >= 10 and wood >= 10: #check for resources for fire		
		var direction
		match dname:
			"up": direction = Vector2(0,-1)
			"down": direction = Vector2(0,1)
			"left": direction = Vector2(-1,0)
			"right": direction = Vector2(1,0)						
		var location = Global.player.global_position + (direction * Global.world.TILE_SIZE)
		var tileLocation = local_to_map(to_local(location))
		#set_cell(tileLocation,0,Vector2i(2,1))
		var backgroundTile = Global.world.background.get_cell_atlas_coords(tileLocation)
		var foregroundTile = get_cell_atlas_coords(tileLocation)
		print(foregroundTile)
		if backgroundTile == Global.world.TILE_TYPES.snow.atlas_pos and foregroundTile == Vector2i(-1,-1):
			Signalbus.useItem.emit(Global.itemType.wood,10)
			Signalbus.useItem.emit(Global.itemType.stone,10)
			spawn(tileLocation, campFireObj)
		
	pass
