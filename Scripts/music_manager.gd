extends Node

var music_player 
var playing_stage_music = false
var playing_title_music = false

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

func manage_title_music():
	if playing_title_music:
		if not music_player.playing:
			music_player.stream = preload("res://Music/TitleScreen.wav")
			music_player.play()
	else:
		if music_player.playing:
			music_player.stop()
	
func manage_stage_music():
	if playing_stage_music:
		if not music_player.playing:
			music_player.stream = preload("res://Music/StageMusicOpening.wav")
			music_player.play()
			await music_player.finished
			music_player.stop()
			music_player.stream = load("res://Music/StageMusicMain.wav")
			music_player.play()
			if not music_player.finished.is_connected(_on_stage_music_finished):
				music_player.finished.connect(_on_stage_music_finished)
	else:
		if music_player.playing:
			music_player.stop()

# Funkcja odbierająca sygnał zakończenia odtwarzania muzyki
func _on_stage_music_finished():
	music_player.play()
