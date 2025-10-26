extends Node2D

## Configuration
const CHUNK_SIZE = 1024 # Your defined chunk size
const CHUNKS_TO_LOAD = 2   # Load/keep chunks within this radius (e.g., 2 means 5x5 grid)

@onready var player = get_parent().get_node("Player")

# Stores instantiated chunks: { Vector2i(chunk_x, chunk_y): Node2D }
var loaded_chunks = {} 

# Stores active loading requests: { Vector2i(chunk_x, chunk_y): String(path) }
var loading_requests = {} 

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
	# A. Schedule new loads for chunks that are required but not loading/loaded
	for coords in required_chunks:
		if not loaded_chunks.has(coords) and not loading_requests.has(coords):
			schedule_load(coords)

	# B. Check the status of existing loading requests
	var completed_requests = []
	for coords in loading_requests.keys():
		var path = loading_requests[coords]
		var status = ResourceLoader.load_threaded_get_status(path)
		
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			continue # Still loading, check next frame
		
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			# Load is complete! Instantiate it now.
			var resource = ResourceLoader.load_threaded_get(path)
			if resource:
				instantiate_chunk(coords, resource)
			completed_requests.append(coords)
			
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			print("Chunk load failed for: ", path)
			completed_requests.append(coords)
			
	# Clean up completed requests from the dictionary
	for coords in completed_requests:
		loading_requests.erase(coords)


func schedule_load(coords: Vector2i):
	#var path = "res://scenes/Chunk_%s_%s.tscn" % [coords.x, coords.y]
	var path = "res://scenes/Chunk.tscn"
	
	print("Loading chunk at (%s, %s)" % [coords.x, coords.y])
	
	if not FileAccess.file_exists(path):
		return
		
	var error = ResourceLoader.load_threaded_request(path)
	if error == OK:
		loading_requests[coords] = path
	else:
		print("Error scheduling load for %s: %s" % [coords, error])


func instantiate_chunk(coords: Vector2i, resource: Resource):
	var new_chunk = resource.instantiate()
	# Load here!
	
	# Position the chunk based on its grid coordinate
	new_chunk.global_position = Vector2(coords.x, coords.y) * CHUNK_SIZE
	add_child(new_chunk)
	loaded_chunks[coords] = new_chunk
	
# --- Unloading ---

func unload_distant_chunks(required_chunks: Array[Vector2i]):
	var chunks_to_unload = []
	for coords in loaded_chunks.keys():
		if not coords in required_chunks:
			chunks_to_unload.append(coords)
			
	for coords in chunks_to_unload:
		var chunk = loaded_chunks[coords]
		
		# Optimization: If a chunk is unloaded, first check if any important object 
		# inside it needs a graceful exit (e.g., saving state).
		
		chunk.queue_free() 
		loaded_chunks.erase(coords)

# ... rest of the script (like _ready) remains empty now ...
