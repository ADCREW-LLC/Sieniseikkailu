extends Control

func _ready():
	$ButtonStack/PlayButton.grab_focus.call_deferred()
	
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
