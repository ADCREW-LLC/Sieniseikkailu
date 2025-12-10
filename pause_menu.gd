extends CanvasLayer

<<<<<<< HEAD
=======

>>>>>>> 065097e (Fixed the score bug and added the mushroom inspect pictures plus button designs)
var is_paused := false

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):									# AKA press ESC
<<<<<<< HEAD
=======
		$Control/PauseStack/ResumeButton.grab_focus()
>>>>>>> 065097e (Fixed the score bug and added the mushroom inspect pictures plus button designs)
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	visible = is_paused
	
	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_button_pressed():
	toggle_pause()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
	
