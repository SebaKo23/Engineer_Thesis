extends CanvasLayer

func _ready():
	MusicManager.playing_stage_music = false
	MusicManager.manage_stage_music()
	
func _on_scene_timer_timeout():
	Global.xp = 0
	Global.rests = 3
	Global.continues = 2
	Global.spawn_dogs = true
	get_tree().change_scene_to_file("res://Scenes/main_menu_screen.tscn")
