extends Node2D

@export var chunk_scene: PackedScene
@export var mushroom_scene: PackedScene
@export var visible_radius: int = 1   # number of chunks to keep loaded around player

var loaded_chunks: Dictionary = {}
const CHUNK_SIZE: int = 2048  # pixels per chunk
var last_chunk := Vector2i.ZERO

func _ready():
	$Camera2D.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Preload scenes if not set in the editor
	if not chunk_scene:
		chunk_scene = preload("res://scenes/Chunk.tscn")
	if not mushroom_scene:
		mushroom_scene = preload("res://scenes/Mushroom.tscn")

	# Load initial area
	var player = $Player
	var current_chunk = Vector2i(
		floor(player.position.x / CHUNK_SIZE),
		floor(player.position.y / CHUNK_SIZE)
	)
	_update_chunks(current_chunk)
	last_chunk = current_chunk


func _process(_delta):
	var player = $Player
	var current_chunk = Vector2i(
		floor(player.position.x / CHUNK_SIZE),
		floor(player.position.y / CHUNK_SIZE)
	)

	# Only update when entering a new chunk
	if current_chunk != last_chunk:
		_update_chunks(current_chunk)
		last_chunk = current_chunk
	
	$Camera2D.position = $Player.position


func _update_chunks(center_chunk: Vector2i):
	# Load necessary chunks around player
	for x in range(center_chunk.x - visible_radius * CHUNK_SIZE, center_chunk.x + (visible_radius + 1) * CHUNK_SIZE):
		for y in range(center_chunk.y - visible_radius * CHUNK_SIZE, center_chunk.y + (visible_radius + 1) * CHUNK_SIZE):
			var coords = Vector2i(x, y)
			if not loaded_chunks.has(coords):
				var chunk = chunk_scene.instantiate()
				chunk.position = Vector2(x * CHUNK_SIZE, y * CHUNK_SIZE)
				add_child(chunk)
				loaded_chunks[coords] = chunk
				_spawn_mushrooms_in_chunk(chunk)

	# Unload chunks too far away
	for coords in loaded_chunks.keys():
		if coords.distance_to(center_chunk) > visible_radius:
			loaded_chunks[coords].queue_free()
			loaded_chunks.erase(coords)


func _spawn_mushrooms_in_chunk(chunk):
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# 50% chance this chunk even has mushrooms
	if rng.randf() > 0.5:
		return

	var num_mushrooms = rng.randi_range(1, 3)  # between 1 and 3 mushrooms
	for i in range(num_mushrooms):
		var mushroom = mushroom_scene.instantiate()
		mushroom.position = chunk.position + Vector2(
			rng.randf_range(0, CHUNK_SIZE),
			rng.randf_range(0, CHUNK_SIZE)
		)

		# Random type (based on real Finnish mushrooms)
		var chance = rng.randf()
		if chance < 0.2:
			mushroom.poisonous = true
			mushroom.type = "Amanita muscaria"  # Fly agaric (poisonous)
		elif chance < 0.6:
			mushroom.poisonous = false
			mushroom.type = "Boletus edulis"   # Porcini (healthy)
		else:
			mushroom.poisonous = false
			mushroom.type = "Cantharellus cibarius" # Chanterelle (healthy)

		chunk.add_child(mushroom)
