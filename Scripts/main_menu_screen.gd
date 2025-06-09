extends CanvasLayer

var options = []
var current_index = 0
var option_pressed = false

@onready var start_text = $PanelContainer/MarginButtonContainer/Rows/StartText
@onready var control_text = $PanelContainer/MarginButtonContainer/Rows/ControlsText
@onready var credits_text = $PanelContainer/MarginButtonContainer/Rows/CreditsText
@onready var quit_text = $PanelContainer/MarginButtonContainer/Rows/QuitText
@onready var start_anim = $PanelContainer/MarginButtonContainer/Rows/StartText/StartAnim
@onready var controls_anim = $PanelContainer/MarginButtonContainer/Rows/ControlsText/ControlsAnim
@onready var credits_anim = $PanelContainer/MarginButtonContainer/Rows/CreditsText/CreditsAnim

func _ready():
	MusicManager.playing_title_music = true
	MusicManager.manage_title_music()
	options = [
		start_text,
		control_text,
		credits_text,
		quit_text
	]
	update()

func _process(_delta):
	update()
	
func _input(event):
	if event.is_action_pressed("ui_up"):
		if not option_pressed:
			$OptionChange.play()
			current_index = (current_index - 1 + options.size()) % options.size()
	elif event.is_action_pressed("ui_down"):
		if not option_pressed:
			$OptionChange.play()
			current_index = (current_index + 1 + options.size()) % options.size()
	elif event.is_action_pressed("ui_accept"):
		if current_index == 0:
			if not option_pressed:
				$OptionAccepted.play()
				MusicManager.music_player.stop()
				start_anim.play("blink")
				$MainMenuTimer.start()
			option_pressed = true
		elif current_index == 1:
			if not option_pressed:
				$OptionAccepted.play()
				controls_anim.play("blink")
				$MainMenuTimer.start()
			option_pressed = true
		elif current_index == 2:
			if not option_pressed:
				$OptionAccepted.play()
				credits_anim.play("blink")
				$MainMenuTimer.start()
			option_pressed = true
		elif current_index == 3:
			get_tree().quit()

func update():
	for i in range(options.size()):
		if i == current_index:
			options[i].label_settings.font_color = Color(1, 1, 1)
		else:
			options[i].label_settings.font_color = Color(0.5, 0.5, 0.5)

func _on_main_menu_timer_timeout():
	if current_index == 0:
		get_tree().change_scene_to_file("res://Scenes/intro_screen.tscn")
	elif current_index == 1:
		get_tree().change_scene_to_file("res://Scenes/options.tscn")
	elif current_index == 2:
		get_tree().change_scene_to_file("res://Scenes/credits.tscn")
