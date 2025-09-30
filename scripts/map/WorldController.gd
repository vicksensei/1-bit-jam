extends Node2D	# This script extends the Node2D class, making it a 2D node in the scene
class_name  WorldController

@onready var background : TileMapDual = $Background	# Reference to the Background TileMap node
@onready var foreground :  = $Foreground	# Reference to the Foreground TileMap node
@onready var bunny_parent : Node2D= $"Bunny Parent"	# Reference to the BunnyParent node for managing bunnies
@onready var player := Global.player		# Reference to the player object from a global singleton
@onready var bunny_scene = preload("res://scenes/prefabs/bunny.tscn")	# Preload the Bunny scene for instantiation

const TILE_TYPES: Dictionary = {
	"snow": {
		"atlas_pos": Vector2i(0, 3),
		"source":0,
		"type":"background"
	},
	"ice": {
		"atlas_pos": Vector2i(2, 1),
		"source":0,
		"type":"background"
	},
	
	"tree": {
		"atlas_pos": Vector2i(1, 1),
		"source":0,
		"type":"foreground"
	},
	
	"stone": {
		"atlas_pos": Vector2i(0, 1),
		"source":0,
		"type":"foreground"
	},
	"mound": {
		"atlas_pos": Vector2i(3, 0),
		"source":0,
		"type":"foreground"
	},
}
	
# Constants for tile generation
const TILE_SIZE := 16					# Size of each tile in pixels
const BUFFER_RADIUS := 14				# Number of tiles to generate around the player
var generated_tiles := {}				# Dictionary to keep track of generated tiles and their types

# Foreground placement radii and bunny spawn chance as constants
const TREE_RADIUS := 3			# Radius of blank snow required for tree placement
const STONE_RADIUS := 2			# Radius of blank snow required for stone placement
const BUNNY_RADIUS := 1			# Radius of blank snow required for bunny placement
const BUNNY_SPAWN_RADIUS := 2	# Distance from tree to search for bunny spawn
const BUNNY_SPAWN_CHANCE := 0.1 # 1% chance to spawn a bunny near a tree

const SNOW_TILE:= Vector2i(0, 3)
const ICE_TILE:=Vector2i(2, 1)
var spawnBunnies := false
var isLoaded = false
func _ready():
	# Called when the node is added to the scene
	Global.world = self
	Signalbus.houseBuilt.connect(enable_bunnies)
	#_generate_starting_area()
	background.update_full_tileset()
	var used_cells = background.get_used_cells()	# Get all currently used cells in the TileMap
	#await get_tree().create_timer(1).timeout
	print(used_cells.size())
	#print(used_cells[0])
	#print(used_cells[used_cells.size()-1])
	for cell in used_cells:
		var atlas = background.get_cell_atlas_coords(cell)	# Get the atlas coords for this cell
		var tile_type = "snow"	# Default tile type
		if atlas == ICE_TILE:
			tile_type = "ice"	# If atlas matches, set as ice
		elif atlas == SNOW_TILE:
			tile_type = "snow"	# If atlas matches, set as snow
		# Add more mappings if you have more tile types
		generated_tiles[cell] = tile_type	# Store the tile type in the dictionary
	isLoaded = true

func _generate_starting_area():
	var area_size = BUFFER_RADIUS +2
	for x in range(-area_size, area_size):
		for y in range(-area_size, area_size):
			background.set_cell(Vector2i(x,y),0,SNOW_TILE)
	background.update_full_tileset()
	
func _process(_delta):
	if isLoaded:
		# Called every frame
		var player_tile := Vector2i(
			floor(player.global_position.x / TILE_SIZE),	# Calculate player's tile X position
			floor(player.global_position.y / TILE_SIZE)		# Calculate player's tile Y position
		)

		# Loop through a square area around the player to generate tiles
		for y in range(player_tile.y - BUFFER_RADIUS, player_tile.y + BUFFER_RADIUS + 1):
			for x in range(player_tile.x - BUFFER_RADIUS, player_tile.x + BUFFER_RADIUS + 1):
				var pos = Vector2i(x, y)	# Current tile position
				if not generated_tiles.has(pos):	# If tile hasn't been generated yet
					_generate_tile(pos)			# Generate the tile
		_find_and_expand_solo_ice()	# Ensure solo ice tiles get a cardinal neighbor

func enable_bunnies():
	spawnBunnies = true
	Global.player.global_position = Vector2(80,80)

# Use TILE_TYPES for atlas lookups instead of _tilename_to_atlas
func _get_atlas_coords(tilename: String) -> Vector2i:
	# Returns the atlas coordinates for a given tile name using TILE_TYPES
	if TILE_TYPES.has(tilename):
		return TILE_TYPES[tilename].atlas_pos
	return Vector2i(-1, -1)

func _generate_tile(pos: Vector2i):
	# Generates a background tile at the given position
	var rng := RandomNumberGenerator.new()
	#rng.seed = hash(pos)
	var tile_type := choose_tile_weighted_by_neighbors(pos, rng)
	background.set_cell(pos, 0, _get_atlas_coords(tile_type))
	background.update_tile(pos)
	generated_tiles[pos] = tile_type
	_generate_foreground_tile(pos, rng)

func _generate_foreground_tile(pos: Vector2i, rng: RandomNumberGenerator):
	if generated_tiles[pos] != "snow":
		return
	if _is_blank_snow_radius(pos, TREE_RADIUS):
		if rng.randf() < 0.01:
			foreground.set_cell(pos, 0, _get_atlas_coords("tree"))
			generated_tiles[pos] = "tree"
			foreground.checkCell(pos) # Remove this if you want to avoid double-spawn
			_try_spawn_bunny_near_tree(pos, rng)
			return
	if _is_blank_snow_radius(pos, STONE_RADIUS):
		if rng.randf() < 0.005:
			foreground.set_cell(pos, 0, _get_atlas_coords("stone"))
			generated_tiles[pos] = "stone"
			foreground.checkCell(pos)
			return
	if rng.randf() < 0.01:
		foreground.set_cell(pos, 0, _get_atlas_coords("mound"))

func _generate_forced_ice(pos: Vector2i):
	background.set_cell(pos, 0, _get_atlas_coords("ice"))
	background.update_tile(pos)
	generated_tiles[pos] = "ice"

func _is_blank_snow_radius(center: Vector2i, radius: int) -> bool:
	# Returns true if all tiles in radius are snow (or ungenerated) and have no foreground
	for y in range(center.y - radius, center.y + radius + 1):
		for x in range(center.x - radius, center.x + radius + 1):
			var pos = Vector2i(x, y)
			if pos == center:
				continue
			# Treat ungenerated tiles as snow
			if generated_tiles.has(pos):
				if generated_tiles[pos] != "snow":
					return false
			# If foreground exists, fail
			if foreground.get_cell_source_id(pos) != -1:
				return false
	return true

func _try_spawn_bunny_near_tree(tree_pos: Vector2i, rng: RandomNumberGenerator):
	if spawnBunnies == false:
		return
	# Try to spawn a bunny within BUNNY_SPAWN_RADIUS tiles of the tree, in a blank spot
	var bunny_candidates = []
	for y in range(tree_pos.y - BUNNY_SPAWN_RADIUS, tree_pos.y + BUNNY_SPAWN_RADIUS + 1):
		for x in range(tree_pos.x - BUNNY_SPAWN_RADIUS, tree_pos.x + BUNNY_SPAWN_RADIUS + 1):
			var pos = Vector2i(x, y)
			if pos == tree_pos:
				continue
			# Must be snow, no foreground, and BUNNY_RADIUS-tile radius of blank
			var is_snow = !generated_tiles.has(pos) or generated_tiles[pos] == "snow"
			var is_blank = foreground.get_cell_source_id(pos) == -1
			if is_snow and is_blank:
				if _is_blank_snow_radius(pos, BUNNY_RADIUS):
					bunny_candidates.append(pos)
	if bunny_candidates.size() > 0 and rng.randf() < BUNNY_SPAWN_CHANCE:
		var bunny_pos = bunny_candidates[rng.randi_range(0, bunny_candidates.size() - 1)]
		_spawn_bunny(bunny_pos)

func _spawn_bunny(pos: Vector2i):
	# Instance and place a bunny at the given position (implement your own bunny scene)
	var bunny = bunny_scene.instantiate()
	bunny.global_position = background.map_to_local(pos)
	bunny_parent.add_child(bunny)

func choose_tile_weighted_by_neighbors(pos: Vector2i, rng: RandomNumberGenerator) -> String:
	
	# Prevent ice from being generated under trees or stones
	if generated_tiles.has(pos) and (generated_tiles[pos] == "tree" or generated_tiles[pos] == "stone"):
		return "snow"
	# Chooses a tile type based on the types of neighboring tiles, with higher chance for ice next to ice
	var counts = {"snow": 0, "ice": 0}	# Count of each neighbor type

	# Count all 8 neighboring tiles
	for offset in [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                 Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1),
	]:
		var npos = pos + offset	# Neighbor position
		if generated_tiles.has(npos):
			var neighbor_type = generated_tiles[npos]
			if counts.has(neighbor_type):
				counts[neighbor_type] += 1	# Increment count for this neighbor type

	# Check for cardinal (non-diagonal) ice neighbors
	var cardinal_ice = false
	for offset in [
		Vector2i(0, -1), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, 1)
	]:
		var npos = pos + offset
		if generated_tiles.has(npos) and generated_tiles[npos] == "ice":
			cardinal_ice = true	# Found a cardinal ice neighbor
			break

	# Set weights for each tile type
	var weights = {"snow": 1.0 + counts["snow"], "ice": 0.0}
	if cardinal_ice:
		weights["ice"] = 0.45 + counts["ice"] * 1.0	# Much higher chance if next to ice
	else:
		weights["ice"] = 0.01	# Very rare seed chance

	# Build a pool for weighted random selection
	var pool = []
	for t in weights:
		for _i in int(weights[t] * 100):
			pool.append(t)

	var rv = "snow"	# Default return value
	if pool.size() > 0:
		rv = pool[rng.randi_range(0, pool.size() - 1)]	# Randomly select from pool
	return rv

func _find_and_expand_solo_ice():
	# Find all solo ice tiles and force a cardinal neighbor to become ice
	var solo_ice_tiles = []	# List to store solo ice tile positions
	for pos in generated_tiles:
		if generated_tiles[pos] == "ice":
			var has_cardinal_ice = false
			# Check all 4 cardinal directions for another ice tile
			for offset in [
				Vector2i(0, -1), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, 1)
			]:
				var npos = pos + offset
				if generated_tiles.has(npos) and generated_tiles[npos] == "ice":
					has_cardinal_ice = true
					break
			if not has_cardinal_ice:
				solo_ice_tiles.append(pos)	# Add solo ice tile to list
	
	for pos in solo_ice_tiles:
		# Try to force a cardinal neighbor to ice
		var candidates = []	# List of candidate positions for new ice
		for offset in [
			Vector2i(0, -1), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, 1)
		]:
			var npos = pos + offset
			if not generated_tiles.has(npos):
				candidates.append(npos)	# Add empty cardinal neighbor as candidate
		if candidates.size() > 0:
			var npos = candidates[randi() % candidates.size()]	# Pick a random candidate
			_generate_forced_ice(npos)	# Force-generate an ice tile here
