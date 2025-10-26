# mushroom.gd
extends Area2D

@export var type: String = "Boletus edulis"  # Default type
@export var poisonous: bool = false          # True if poisonous
@export var points_value: int = 1            # Points for healthy mushrooms

var player_in_range = false

func _ready():
	# Connect collision signals
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	# Color coding for visual feedback
	match type:
		"Amanita muscaria": # poisonous
			poisonous = true
			points_value = 0
			#$Sprite.modulate = Color.RED
		"Boletus edulis": # healthy
			poisonous = false
			points_value = 1
			#$Sprite.modulate = Color.BROWN
		"Cantharellus cibarius": # healthy
			poisonous = false
			points_value = 2
			#$Sprite.modulate = Color.YELLOW
		#_:
			#$Sprite.modulate = Color.WHITE

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		if poisonous:
			body.on_poisonous_mushroom_touched()

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func _process(_delta):
	# Collect healthy mushroom if player presses Space
	if player_in_range and not poisonous:
		if Input.is_action_just_pressed("ui_accept"):
			var player = get_overlapping_bodies().find(func(b): return b.name == "Player")
			if player:
				player.on_healthy_mushroom_collected(points_value)
				queue_free()
