extends Area2D

@export var duration: float = 0.5												#Duration of pickup
@export var type: String = "Boletus edulis"
var timer := 0.0
var active := false

@onready var popup = get_node("/root/Main/PickupUI/MushroomPopup")
var current_mushroom: Area2D = null

const Mushroom_Inspect_Sprites := {
	"Boletus edulis": preload("res://arts/Inspect Images/Boletus edulis.png"),
	"Amanita muscaria": preload("res://arts/Inspect Images/Amanita muscaria.png"),
	"Chanterelle": preload("res://arts/Inspect Images/Chanterrelle.png"),
	"Amanita Virosa": preload("res://arts/Inspect Images/Amanita virosa.png"),
	"Hygrocybe Chlorophana": preload("res://arts/Inspect Images/Hygrocybe chlorophana.png"),
	"Hygrocybe Punicea": preload("res://arts/Inspect Images/Hygrocybe punicea.png"),
	"Suillus Grevillei": preload("res://arts/Inspect Images/Suillus grevillei.png"),
	"Russula Paludosa": preload("res://arts/Inspect Images/Russula paludosa.png")
}

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
	
var collected_mushrooms = [] 									#Stores mushrooms in this array

func _on_area_entered(area: Area2D):
	
	if area.is_in_group("Mushroom") and current_mushroom == null:
		current_mushroom = area
		var mushroom_type = area.type
		if Mushroom_Inspect_Sprites.has(mushroom_type):
			print("Setting inspect image for type:", mushroom_type)
			$/root/Main/PickupUI/MushroomPopup/MushroomImage.texture = Mushroom_Inspect_Sprites[mushroom_type]
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
	$/root/Main/PickupUI/MushroomPopup/PickupStack/Collect.grab_focus()
	#popup.get_node("TextureRect").texture = null area.mushroom_texture  #Currently broken since there isnt a texuture set for the mushrooms, add later
	#popup.get_node("MushroomInfo").text = "This is a " + area.type #This also isnt being used right now but im leaving it here to be used later
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

func _on_collect_pressed():
	if current_mushroom:
		Scoremanager.add_points(current_mushroom.points_value)
		Scoremanager.add_pcount(current_mushroom.poisonous)
		Scoremanager.add_ecount(current_mushroom.edible)
		collected_mushrooms.append(current_mushroom)
		print(collected_mushrooms)
		current_mushroom.queue_free()
		current_mushroom = null
		close_popup()

func _on_leave_pressed():
	current_mushroom = null
	close_popup()

func close_popup():
	popup.visible = false
	get_tree().paused = false
