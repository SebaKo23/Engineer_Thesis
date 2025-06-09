extends Node2D

#Funkcja wywołująca się, gdy węzeł zostanie przyłączony do drzewa
func _ready():
	Global.prev_scene = get_tree().current_scene.scene_file_path
	MusicManager.playing_stage_music = true
	MusicManager.manage_stage_music()
	
#Funkcja przechwytująca sygnał, czy gracz wszedł w obszar zakończenia poziomu
func _on_stage_end_body_entered(_body):
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/stage_2_intro.tscn")


func _on_kill_zone_body_entered(body):
	if body.is_in_group("Player"):
		body.kill_player_pitfall()

