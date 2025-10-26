# chunk.gd
extends Node2D

@export var chunk_size: Vector2 = Vector2(2048, 2048)  # size of this chunk in pixels
@export var chunk_coords: Vector2i = Vector2i(0, 0)   # coordinates of this chunk in the grid

func _ready():
	# Placeholder for future tilemap or mushrooms
	# For now, chunk is just a Node2D container
	pass
