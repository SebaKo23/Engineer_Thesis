extends CanvasLayer

func _on_scene_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/stage_1_intro.tscn")
