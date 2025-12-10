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
<<<<<<< HEAD
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
=======
const MUSHROOM_SPRITES := {
	"Boletus edulis": preload("res://arts/mushrooms/boletus_edulis.png"),
	"Amanita muscaria": preload("res://arts/mushrooms/amanita_muscaria.png"),
	"Chanterelle": preload("res://arts/mushrooms/chanterelle.png"),
	"Amanita Virosa": preload("res://arts/mushrooms/Amanita-virosa.png"),
	"Hygrocybe Chlorophana": preload("res://arts/mushrooms/Hygrocybe-chlorophana.png"),
	"Hygrocybe Punicea": preload("res://arts/mushrooms/Hygrocybe-punicea.png"),
	"Suillus Grevillei": preload("res://arts/mushrooms/suillus-grevillei.png"),
	"Russula Paludosa": preload("res://arts/mushrooms/Russula-paludosa.png")
}
const Mushroom_Inspect_Sprites := {
	"Boletus edulis": preload("res://arts/Inspect Images/Boletus edulis.png"),
	"Amanita muscaria": preload("res://arts/Inspect Images/Amanita muscaria.png"),
	"Chanterelle": preload("res://arts/Inspect Images/Chanterrelle.png"),
	"Amanita Virosa": preload("res://arts/Inspect Images/Amanita virosa.png"),
	"Hygrocybe Chlorophana": preload("res://arts/Inspect Images/Hygrocybe chlorophana.png"),
	"Hygrocybe Punicea": preload("res://arts/Inspect Images/Hygrocybe punicea.png"),
	"Suillus Grevillei": preload("res://arts/Inspect Images/Suillus grevillei.png"),
	"Russula Paludosa": preload("res://arts/Inspect Images/Russula paludosa.png")
>>>>>>> 065097e (Fixed the score bug and added the mushroom inspect pictures plus button designs)
}

func _ready():
	# Connect collision signals
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
	# Set visuals based on type
<<<<<<< HEAD
	sprite.texture = MUSHROOM_DATA[type]["sprite"]

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		if poisonous:
			body.on_poisonous_mushroom_touched()

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
=======
	if MUSHROOM_SPRITES.has(type):
		sprite.texture = MUSHROOM_SPRITES[type]
	else:
		push_warning("Unknown mushroom type: %s" % type)
		
	if Mushroom_Inspect_Sprites.has(type):
		get_node("/root/Main/PickupUI/MushroomPopup/MushroomImage").texture = Mushroom_Inspect_Sprites[type]

	# Color coding for visual feedback
	match type:
		"Amanita muscaria": # poisonous
			poisonous = true
			edible = false    # it's poisonous, so this is false
			points_value = 1
		"Boletus edulis": # healthy
			poisonous = false
			edible = true     # it's edible, so this is true
			points_value = 1
		"Cantharellus cibarius": # healthy 
			poisonous = false
			edible = true 
			points_value = 1
		"Amanita Virosa":
			poisonous = true
			edible = false 
			points_value = 1
		"Hygrocybe Chlorophana":
			poisonous = true
			edible = false 
			points_value = 1
		"Hygrocybe Punicea": 
			poisonous = false
			edible = true 
			points_value = 1
		"Suillus Grevillei":
			poisonous = false
			edible = true 
			points_value = 1
		"Russula Paludosa":
			poisonous = false
			edible = true 
			points_value = 1
			
		#_:  #(If we want to add more types. Added this as a comment to avoid interference with chantarellus' code.)
			#poisonous = false # neutral
			#points_value = 1
>>>>>>> 065097e (Fixed the score bug and added the mushroom inspect pictures plus button designs)
