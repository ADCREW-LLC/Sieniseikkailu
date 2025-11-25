extends Control

func _on_quit_pressed():
	get_tree().quit()

func _on_try_again_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _process(delta: float) -> void:
	$Scoreboard/VBoxContainer/Edible.text = "Edible: " + str(Scoremanager.edible_count)
	$Scoreboard/VBoxContainer/Poisonous.text = "Poisonous: " + str(Scoremanager.poisonous_count)
	#$Scoreboard/VBoxContainer/TypesList.text = str(PickupArea.get_collected_mushrooms())
	#Currently This is bugged and I cant get it to work right now so I or someone else should try to fix it later
