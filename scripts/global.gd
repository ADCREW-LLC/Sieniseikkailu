extends Node

# This will contain all mushroom info per chunk
# Format: { Vector2i(chunk_x, chunk_y): [ { "type": "Boletus", "pos": Vector2(120, 300) }, ... ] }
var WORLD_MUSHROOM_DATA: Dictionary = {}

const MUSHROOM_TYPES = [
	{ "name": "Boletus edulis", "scene": preload("res://scenes/Mushroom.tscn") },
	{ "name": "Amanita muscaria", "scene": preload("res://scenes/Mushroom.tscn") },
	{ "name": "Chanterelle", "scene": preload("res://scenes/Mushroom.tscn") }
]

func _ready():
	# Generate the global mushroom world once
	generate_world_mushrooms()

func generate_world_mushrooms():
	var rng = RandomNumberGenerator.new()
	var WORLD_SIZE = 100  # number of chunks in x and y

	for cx in range(-WORLD_SIZE, WORLD_SIZE):
		for cy in range(-WORLD_SIZE, WORLD_SIZE):
			var coords = Vector2i(cx, cy)
			var mushrooms = []

			var mushroom_count = rng.randi_range(2, 5)
			for i in range(mushroom_count):
				var data = MUSHROOM_TYPES.pick_random()
				mushrooms.append({
					"type": data["name"],
					"scene": data["scene"],
					"pos": Vector2(rng.randf_range(0, 1024), rng.randf_range(0, 1024))
				})
			
			WORLD_MUSHROOM_DATA[coords] = mushrooms
