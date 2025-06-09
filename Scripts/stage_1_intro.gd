extends CanvasLayer

func _ready():
	MusicManager.playing_stage_music = true
	MusicManager.manage_stage_music()
	
func _on_scene_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/Stage1.tscn")
