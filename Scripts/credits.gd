extends CanvasLayer

var options

@onready var back_text = $PanelContainer/BackContainer/BackText
@onready var back_anim = $PanelContainer/BackContainer/BackText/BackAnim


func _ready():
	MusicManager.playing_title_music = true
	MusicManager.manage_title_music()
	options = back_text
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
				$OptionAccepted.play()
				back_anim.play("blink")
				$CreditsTimer.start()

func _on_credits_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/main_menu_screen.tscn")
