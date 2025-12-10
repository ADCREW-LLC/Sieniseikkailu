extends Node2D

func _ready():
	RandomNumberGenerator.new().randomize()  # or see below for better way
	$Camera2D.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	$Camera2D.position = $Player.position
