extends Node

const CHUNK_SIZE = 640 # Your defined chunk size, should be the same size of the background image of the chunk
const OBJECT_MARGIN = 0
const OBJECT_PER_CHUNK = 30

var WORLD_MUSHROOM_DATA: Dictionary = {}
var WORLD_STATIC_DATA: Dictionary = {}

const Mushrooms = preload("res://scripts/mushroom.gd")

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
				if randi_range(1, 10) <= 5: 
					var key = Mushrooms.MUSHROOM_DATA.keys().pick_random()
					var data = Mushrooms.MUSHROOM_DATA[key]
					mushrooms.append({
						"type": key,
						"scene": data["scene"],
						"pos": pos
					})
				else:
					objects.append({
						"pos": pos
					})
			
			WORLD_MUSHROOM_DATA[coords] = mushrooms
			WORLD_STATIC_DATA[coords] = objects
