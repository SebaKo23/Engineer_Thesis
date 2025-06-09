extends Node2D

func _ready():
	Global.prev_scene = get_tree().current_scene.scene_file_path
	MusicManager.playing_stage_music = true
	MusicManager.manage_stage_music()
	
func _on_stage_end_body_entered(_body):
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/stage_3_intro.tscn")
