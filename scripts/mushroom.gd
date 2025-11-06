# mushroom.gd
extends Area2D

@export var type: String = "Boletus edulis"  # Default type
@export var poisonous: bool = false          # True if poisonous
@export var points_value: int = 1            # Points for healthy mushrooms

var player_in_range = false

# Get the sprite node
@onready var sprite: Sprite2D = $Sprite2D

# --- preload textures or animations for each mushroom type ---
const MUSHROOM_SPRITES := {
	"Boletus edulis": preload("res://arts/mushrooms/boletus_edulis.png"),
	"Amanita muscaria": preload("res://arts/mushrooms/amanita_muscaria.png"),
	"Chanterelle": preload("res://arts/mushrooms/chanterelle.png")
}

func _ready():
	# Connect collision signals
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
	# Set visuals based on type
	if MUSHROOM_SPRITES.has(type):
		sprite.texture = MUSHROOM_SPRITES[type]
	else:
		push_warning("Unknown mushroom type: %s" % type)

	# Color coding for visual feedback
	match type:
		"Amanita muscaria": # poisonous
			poisonous = true
			points_value = -1
		"Boletus edulis": # healthy
			poisonous = false
			points_value = 1
		"Cantharellus cibarius": # healthy
			poisonous = false
			points_value = 2
		_:
			poisonous = false # neutral
			points_value = 0

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		if poisonous:
			body.on_poisonous_mushroom_touched()

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
