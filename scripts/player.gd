# player.gd
extends Area2D

@export var speed: float = 150.0   # Player movement speed
var health: int = 5                # Starting health
var points: int = 0                # Collected mushroom points

@export var duration: float = 0.5  # Duration of pickup
var timer := 0.0
var active := false

var velocity: Vector2 = Vector2.ZERO

var facing_direction = Vector2.ZERO

@onready var pickup_area = $PickupArea

func _process(delta):
	# Reset velocity
	velocity = Vector2.ZERO
	pickup_area.position = Vector2.ZERO

	# Handle movement input
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# Handle movement + animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		_play_step_sound()
	else:
		$AnimatedSprite2D.stop()
		_stop_step_sound()

	# Move player manually
	if velocity != Vector2.ZERO:
		position += velocity * delta

	# Direction handling + scaling
	if velocity.x != 0:
		if velocity.x > 0:
			facing_direction = Vector2(150,0) #Right
		else:
			facing_direction = Vector2(-150,0) #Left

		$AnimatedSprite2D.animation = &"right"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0

		# Scale horizontally facing animations
		$AnimatedSprite2D.scale = Vector2(1.0, 1.0)  # normal size

	elif velocity.y != 0:
		if velocity.y < 0:
			facing_direction = Vector2(0,-150) #Up
			$AnimatedSprite2D.animation = &"up"
		else:
			facing_direction = Vector2(0,150) #Down
			$AnimatedSprite2D.animation = &"down"

		# Scale vertical-facing animations
		$AnimatedSprite2D.scale = Vector2(0.8, 0.8)  # slightly smaller
		
	if Input.is_action_pressed("pickup"):			#Sets the postion when you press pickup
		pickup_area.position = facing_direction		#This might be redundant but it isnt ineffiecent enough to fix

func _play_step_sound():
	if not $FootstepForest.playing:
		$FootstepForest.play()

func _stop_step_sound():
	if $FootstepForest.playing:
		$FootstepForest.stop()
