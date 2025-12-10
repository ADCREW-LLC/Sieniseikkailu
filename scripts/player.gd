# player.gd
extends CharacterBody2D # Switched to CharacterBody2D

@export var speed: float = 250.0 # Player movement speed
var health: int = 5 # Starting health
var points: int = 0 # Collected mushroom points

@export var duration: float = 0.5 # Duration of pickup
var timer := 0.0
var active := false

# velocity is a built-in property of CharacterBody2D, but we initialize it here
var facing_direction = Vector2.ZERO

@onready var pickup_area = $PickupArea
# --- ADDED: Reference to the Idle Timer node (must be named IdleTimer in scene) ---
@onready var idle_timer = $Timer
# ---------------------------------------------------------------------------------

# --- ADDED: _ready function to configure and connect the Timer ---
func _ready():
	idle_timer.one_shot = true
	# Connects the timeout signal to the new handler function
	idle_timer.timeout.connect(_on_idle_timer_timeout)
# -----------------------------------------------------------------

# Switched to _physics_process for reliable physics updates.
func _physics_process(delta):
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
		# 1. Moving State
		velocity = velocity.normalized() * speed
		
		# --- MODIFIED: Stop the timer immediately when movement starts ---
		if idle_timer.is_stopped() == false:
			idle_timer.stop()
		# ----------------------------------------------------------------
		
		_play_step_sound()
	else:
		# 2. Idle State - Start the Timer
		velocity = Vector2.ZERO
		_stop_step_sound()
		
		# --- MODIFIED: Start the timer to trigger idle after a delay ---
		if idle_timer.is_stopped():
			idle_timer.start()
		# ----------------------------------------------------------------

	move_and_slide()

	# Direction handling + scaling
	if velocity.x != 0:
		if velocity.x > 0:
			facing_direction = Vector2(150, 0) # Right
		else:
			facing_direction = Vector2(-150, 0) # Left

		$AnimatedSprite2D.animation = &"right"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	# --- MODIFIED: Only play the animation here if it's a movement animation ---
		$AnimatedSprite2D.play()
	# --------------------------------------------------------------------------
		
	elif velocity.y != 0:
		if velocity.y < 0:
			facing_direction = Vector2(0, -150) # Up
			$AnimatedSprite2D.animation = &"up"
		else:
			facing_direction = Vector2(0, 150) # Down
			$AnimatedSprite2D.animation = &"down"
			
	# --- MODIFIED: Only play the animation here if it's a movement animation ---
		$AnimatedSprite2D.play()
	# --------------------------------------------------------------------------
		
	else:
		# --- MODIFIED: REMOVED immediate idle setting. ---
		# The animation is NOT set to "idle" here anymore. 
		# It keeps the last frame of the movement animation.
		# This block is now empty for animation/direction setting
		# to allow the timer to handle the idle state.
		pass
		
	# --- MODIFIED: REMOVED redundant $AnimatedSprite2D.play() from the end. 
	# It is now called inside the movement-state blocks and the timer function.
	# $AnimatedSprite2D.play()
	# -------------------------------------------------------------------------
		
	if Input.is_action_pressed("pickup"): # Sets the postion when you press pickup
		pickup_area.position = facing_direction # This might be redundant but it isnt ineffiecent enough to fix

# --- ADDED: Handler function for the IdleTimer timeout ---
func _on_idle_timer_timeout():
	# Only switch to idle if the player is still not moving
	if velocity.length_squared() == 0:
		$AnimatedSprite2D.animation = &"idle"
		$AnimatedSprite2D.play()
		# Ensure facing direction is set for the idle pose
		facing_direction = Vector2(-150, 0) # Example: Default idle facing left
# ----------------------------------------------------------

func _play_step_sound():
	if not $FootstepForest.playing:
		$FootstepForest.play()

func _stop_step_sound():
	if $FootstepForest.playing:
		$FootstepForest.stop()
