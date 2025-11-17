extends Area2D

@export var duration: float = 0.5												#Duration of pickup
var timer := 0.0
var active := false

@onready var popup = get_node("/root/Main/PickupUI/MushroomPopup")
var current_mushroom: Area2D = null

func _ready():
	deactivate_area()

func _process(delta):
	if Input.is_action_just_pressed("pickup") and not active:
		activate_area(duration)
	
	if active:																	#Timer
		timer -= delta
		if timer <= 0.0:
			deactivate_area()

func activate_area(time: float):
	timer = time
	active = true
	self.visible = true
	self.set_deferred("monitoring", true)  # enable collision detection

func deactivate_area():
	active = false
	self.visible = false
	self.set_deferred("monitoring", false)  # disable collision detection
	
var collected_mushrooms: Array = [] 									#Stores mushrooms in this array

func _on_area_entered(area: Area2D):
	
	if area.is_in_group("Mushroom") and current_mushroom == null:
		current_mushroom = area
		open_popup(area)
	#if not collected_mushrooms.has(area):
	#	area.name = area.type
	#	Scoremanager.add_points(area.points_value) #Adds the points value (1 for everything) to the counter
	#	Scoremanager.add_pcount(area.poisonous)	 #Adds the poisonous mushroom count if picked up
	#	Scoremanager.add_ecount(area.edible)	#Adds the edible mushroom count if picked up
	#	collected_mushrooms.append(area)
	#	print("Area entered:", area.name)								#just for debugging to show what mushroom you collected
	#	area.queue_free()

func get_collected_mushrooms() -> Array:
	return collected_mushrooms
	
func open_popup(area: Area2D):
	popup.visible = true
	# popup.get_node("TextureRect").texture = null area.mushroom_texture  #Currently broken since there isnt a texuture set for the mushrooms, add later
	#popup.get_node("MushroomInfo").text = "This is a " + area.type #This also isnt being used right now but im leaving it here to be used later
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

func _on_collect_pressed():
	if current_mushroom:
		Scoremanager.add_points(current_mushroom.points_value)
		Scoremanager.add_pcount(current_mushroom.poisonous)
		Scoremanager.add_ecount(current_mushroom.edible)
		current_mushroom.queue_free()
		current_mushroom = null
		close_popup()

func _on_leave_pressed():
	current_mushroom = null
	close_popup()

func close_popup():
	popup.visible = false
	get_tree().paused = false
