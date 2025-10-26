# player.gd
extends Area2D

@export var speed: float = 150.0   # Player movement speed
var health: int = 5                # Starting health
var points: int = 0                # Collected mushroom points

var velocity: Vector2 = Vector2.ZERO

func _process(delta):
	# Reset velocity
	velocity = Vector2.ZERO

	# Handle movement input
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		_play_step_sound()
	else:
		$AnimatedSprite2D.stop()
		_stop_step_sound()

	# Normalize and apply speed
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed
		position += velocity * delta  # manually move player
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = &"right"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = &"up" if velocity.y < 0 else &"down"
		
func _play_step_sound():
	if not $FootstepForest.playing:
		$FootstepForest.play()

func _stop_step_sound():
	if $FootstepForest.playing:
		$FootstepForest.stop()

# Called when touching a poisonous mushroom
func on_poisonous_mushroom_touched():
	health -= 1
	print("Ouch! Poisonous mushroom touched! Health:", health)
	if health <= 0:
		print("Game Over!") # Later: trigger a restart/death screen

# Called when touching a healthy mushroom
func on_healthy_mushroom_collected(points_value: int):
	points += points_value
	print("Collected healthy mushroom! Points:", points)
