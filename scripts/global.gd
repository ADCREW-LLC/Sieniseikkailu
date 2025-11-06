extends Node

const CHUNK_SIZE = 1024 # Your defined chunk size, should be the same size of the background image of the chunk
const OBJECT_MARGIN = 0
const OBJECT_PER_CHUNK = 10

var WORLD_MUSHROOM_DATA: Dictionary = {}
var WORLD_STATIC_DATA: Dictionary = {}

const MUSHROOM_TYPES = [
	{ "name": "Boletus edulis", "scene": preload("res://scenes/Mushroom.tscn") },
	{ "name": "Amanita muscaria", "scene": preload("res://scenes/Mushroom.tscn") },
	{ "name": "Chanterelle", "scene": preload("res://scenes/Mushroom.tscn") }
]

func _ready():
	# Generate the global data
	generate_world_data()

func generate_world_data():
	var rng = RandomNumberGenerator.new()
	var WORLD_SIZE = 100  # number of chunks in x and y
	
	for cx in range(-WORLD_SIZE, WORLD_SIZE):
		for cy in range(-WORLD_SIZE, WORLD_SIZE):
			var coords = Vector2i(cx, cy)
			var mushrooms = []
			var objects = []
			
			var item_count = rng.randi_range(1, OBJECT_PER_CHUNK)
			for i in range(item_count):
				var pos = Vector2(rng.randf_range(OBJECT_MARGIN, CHUNK_SIZE - OBJECT_MARGIN), 
					rng.randf_range(OBJECT_MARGIN, CHUNK_SIZE - OBJECT_MARGIN))
				if randi_range(1, 10) <= 3: 
					var data = MUSHROOM_TYPES.pick_random()
					mushrooms.append({
						"type": data["name"],
						"scene": data["scene"],
						"pos": pos
					})
				else:
					objects.append({
						"pos": pos
					})
			
			WORLD_MUSHROOM_DATA[coords] = mushrooms
			WORLD_STATIC_DATA[coords] = objects
