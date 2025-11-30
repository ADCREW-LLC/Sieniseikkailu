# mushroom.gd
extends Area2D

@export var type: String = "Boletus edulis"  # Default type
@export var poisonous: bool = false          # True if poisonous
@export var points_value: int = 1            # Counts the mushrooms to points // using this as an easy access to counter
@export var edible: bool = true              # Easy access to counting the amount of edible mushrooms

var player_in_range = false

# Get the sprite node
@onready var sprite: Sprite2D = $Sprite2D

# --- preload textures or animations for each mushroom type ---
const MUSHROOM_DATA := {
	"Boletus edulis": {
		"sprite": preload("res://arts/mushrooms/boletus_edulis.png"),
		"scene": preload("res://scenes/Mushroom.tscn"),
		"poisonous": false,
		"edible": true,
		"points_value": 1
	},

	"Amanita muscaria": {
		"sprite": preload("res://arts/mushrooms/amanita_muscaria.png"),
		"scene": preload("res://scenes/Mushroom.tscn"),
		"poisonous": true,
		"edible": false,
		"points_value": -1
	},

	"Chanterelle": { # same as Cantharellus cibarius
		"sprite": preload("res://arts/mushrooms/chanterelle.png"),
		"scene": preload("res://scenes/Mushroom.tscn"),
		"poisonous": false,
		"edible": true,
		"points_value": 1
	},

	"Amanita Virosa": {
		"sprite": preload("res://arts/mushrooms/Amanita-virosa.png"),
		"scene": preload("res://scenes/Mushroom.tscn"),
		"poisonous": true,
		"edible": false,
		"points_value": -1
	},

	"Hygrocybe Chlorophana": {
		"sprite": preload("res://arts/mushrooms/Hygrocybe-chlorophana.png"),
		"scene": preload("res://scenes/Mushroom.tscn"),
		"poisonous": true,
		"edible": false,
		"points_value": -1
	},

	"Hygrocybe Punicea": {
		"sprite": preload("res://arts/mushrooms/Hygrocybe-punicea.png"),
		"scene": preload("res://scenes/Mushroom.tscn"),
		"poisonous": false,
		"edible": true,
		"points_value": 1
	},

	"Suillus Grevillei": {
		"sprite": preload("res://arts/mushrooms/suillus-grevillei.png"),
		"scene": preload("res://scenes/Mushroom.tscn"),
		"poisonous": false,
		"edible": true,
		"points_value": 1
	},

	"Russula Paludosa": {
		"sprite": preload("res://arts/mushrooms/Russula-paludosa.png"),
		"scene": preload("res://scenes/Mushroom.tscn"),
		"poisonous": false,
		"edible": true,
		"points_value": 1
	}
}

func _ready():
	# Connect collision signals
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
	# Set visuals based on type
	sprite.texture = MUSHROOM_DATA[type]["sprite"]
	
func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		if poisonous:
			body.on_poisonous_mushroom_touched()

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
