extends CanvasLayer

func _on_scene_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/main_menu_screen.tscn")
