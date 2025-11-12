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
			
		#_:  #(If we want to add more types. Added this as a comment to avoid interference with chantarellus' code.)
			#poisonous = false # neutral
			#points_value = 1

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		if poisonous:
			body.on_poisonous_mushroom_touched()

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
