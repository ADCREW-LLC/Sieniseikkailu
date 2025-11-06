extends Area2D

@export var duration: float = 0.5												#Duration of pickup
var timer := 0.0
var active := false

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
	if area.is_in_group("Mushroom"):
		if not collected_mushrooms.has(area):
			area.name = area.type
			collected_mushrooms.append(area)
			print("Area entered:", area.name)								#just for debugging to show what mushroom you collected
			area.queue_free()

func get_collected_mushrooms() -> Array:
	return collected_mushrooms
