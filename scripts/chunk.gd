extends Node2D

## Configuration
const CHUNKS_TO_LOAD = 2   # Load/keep chunks within this radius (e.g., 2 means 5x5 grid)

@onready var player = get_parent().get_node("Player")

# Stores instantiated chunks: { Vector2i(chunk_x, chunk_y): Node2D }
var loaded_chunks = {} 

# Stores active loading requests: { Vector2i(chunk_x, chunk_y): String(path) }
var loading_requests = {} 

## Core Logic: Get the chunk coordinates based on player position
func get_chunk_coords(global_pos: Vector2) -> Vector2i:
	var chunk_x = floor(global_pos.x / Global.CHUNK_SIZE)
	var chunk_y = floor(global_pos.y / Global.CHUNK_SIZE)
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
	
	new_chunk.global_position = Vector2(coords.x, coords.y) * Global.CHUNK_SIZE
	add_child(new_chunk)
	loaded_chunks[coords] = new_chunk
	
	spawn_mushrooms_from_global_data(new_chunk, coords)
	spawn_objects_from_global_data(new_chunk, coords)
	
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
			chunk.add_child(mushroom, false)

# --- Injected helper function ---
func spawn_objects_from_global_data(chunk: Node2D, coords: Vector2i):
	if not Global.WORLD_STATIC_DATA.has(coords):
		return
	var scene = preload("res://scenes/StaticObject.tscn")
	if scene:
		for object_data in Global.WORLD_STATIC_DATA[coords]:
			var object = scene.instantiate()
			object.position = object_data["pos"]
			chunk.add_child(object)
