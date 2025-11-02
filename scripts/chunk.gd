extends Node2D

## Configuration!!!
const CHUNK_SIZE = 1024 # Your defined chunk size
const CHUNKS_TO_LOAD = 2   # Load/keep chunks within this radius (e.g., 2 means 5x5 grid)

@onready var player = get_parent().get_node("Player")

# Stores instantiated chunks: { Vector2i(chunk_x, chunk_y): Node2D }
var loaded_chunks = {} 

# Stores active loading requests: { Vector2i(chunk_x, chunk_y): String(path) }
var loading_requests = {} 

# --- Injected: preload static object scene and textures ---
var StaticObjectScene: PackedScene = preload("res://scenes/StaticObject.tscn")
const STATIC_OBJECTS_PER_CHUNK := 20  # how many decorative static objects to spawn per chunk
const STATIC_OBJECT_EDGE_MARGIN := 64  # pixels of safety from the chunk border
# ----------------------------------------------------------

## Core Logic: Get the chunk coordinates based on player position
func get_chunk_coords(global_pos: Vector2) -> Vector2i:
	var chunk_x = floor(global_pos.x / CHUNK_SIZE)
	var chunk_y = floor(global_pos.y / CHUNK_SIZE)
	return Vector2i(chunk_x, chunk_y)

func _process(_delta):
	if player == null:
		return
	var current_chunk_coords = get_chunk_coords(player.global_position)
	
	# 1. Determine which chunks need to be active
	var required_chunks: Array[Vector2i] = []
	for x in range(-CHUNKS_TO_LOAD, CHUNKS_TO_LOAD + 1):
		for y in range(-CHUNKS_TO_LOAD, CHUNKS_TO_LOAD + 1):
			required_chunks.append(current_chunk_coords + Vector2i(x, y))
	
	# 2. Check for completed loads and schedule new loads
	check_and_load_new_chunks(required_chunks)
			
	# 3. Unload Distant Chunks
	unload_distant_chunks(required_chunks)

# --- Loading and Status Checking ---

func check_and_load_new_chunks(required_chunks: Array[Vector2i]):
	for coords in required_chunks:
		if not loaded_chunks.has(coords) and not loading_requests.has(coords):
			schedule_load(coords)

	var completed_requests = []
	for coords in loading_requests.keys():
		var path = loading_requests[coords]
		var status = ResourceLoader.load_threaded_get_status(path)
		
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			continue
		
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var resource = ResourceLoader.load_threaded_get(path)
			if resource:
				instantiate_chunk(coords, resource)
			completed_requests.append(coords)
			
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			print("Chunk load failed for: ", path)
			completed_requests.append(coords)
			
	for coords in completed_requests:
		loading_requests.erase(coords)

func schedule_load(coords: Vector2i):
	var path = "res://scenes/Chunk.tscn"
	var error = ResourceLoader.load_threaded_request(path)
	if error == OK:
		loading_requests[coords] = path
	else:
		print("Error scheduling load for %s: %s" % [coords, error])

func instantiate_chunk(coords: Vector2i, resource: Resource):
	var new_chunk = resource.instantiate()
	
	# --- Injected: random decorative static objects ---
	spawn_static_static_objects(new_chunk)
	# -----------------------------------------
	
	new_chunk.global_position = Vector2(coords.x, coords.y) * CHUNK_SIZE
	add_child(new_chunk)
	loaded_chunks[coords] = new_chunk
	
	spawn_mushrooms_from_global_data(new_chunk, coords)

# --- Unloading ---

func unload_distant_chunks(required_chunks: Array[Vector2i]):
	var chunks_to_unload = []
	for coords in loaded_chunks.keys():
		if not coords in required_chunks:
			chunks_to_unload.append(coords)
			
	for coords in chunks_to_unload:
		var chunk = loaded_chunks[coords]
		chunk.queue_free() 
		loaded_chunks.erase(coords)

func spawn_mushrooms_from_global_data(chunk: Node2D, coords: Vector2i):
	if not Global.WORLD_MUSHROOM_DATA.has(coords):
		return
	
	for mushroom_data in Global.WORLD_MUSHROOM_DATA[coords]:
		var scene = mushroom_data["scene"]
		if scene:
			var mushroom = scene.instantiate()
			mushroom.position = mushroom_data["pos"]
			mushroom.type = mushroom_data["type"]
			chunk.add_child(mushroom)

# --- Injected helper function ---
func spawn_static_static_objects(chunk: Node2D):
	
	for i in STATIC_OBJECTS_PER_CHUNK:
		var staticObject = StaticObjectScene.instantiate()
		
		# keep a safe distance from chunk edges
		var pos_x = randi_range(STATIC_OBJECT_EDGE_MARGIN, CHUNK_SIZE - STATIC_OBJECT_EDGE_MARGIN)
		var pos_y = randi_range(STATIC_OBJECT_EDGE_MARGIN, CHUNK_SIZE - STATIC_OBJECT_EDGE_MARGIN)
		staticObject.position = Vector2(pos_x, pos_y)
		
		chunk.add_child(staticObject)
