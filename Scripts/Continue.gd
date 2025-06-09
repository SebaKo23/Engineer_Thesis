extends CanvasLayer

var options = []
var current_index = 0
var option_pressed = false

@onready var continue_text = $PanelContainer/MarginContainer/Rows/Options/ContinueText
@onready var end_text = $PanelContainer/MarginContainer/Rows/Options/EndText
@onready var continue_anim = $PanelContainer/MarginContainer/Rows/Options/ContinueText/ContinueAnimation
@onready var end_anim = $PanelContainer/MarginContainer/Rows/Options/EndText/EndAnimation

func _ready():
	MusicManager.playing_stage_music = false
	MusicManager.manage_stage_music()
	options = [
		continue_text,
		end_text
	]
	update()

func _process(_delta):
	continue_text.text = "CONTINUE " + str(Global.continues)
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
				option_pressed = true
				$OptionAccepted.play()
				Global.continues -= 1
				Global.rests = 3
				Global.xp = 0
				Global.spawn_dogs = true
				continue_anim.play("blink")
				$ContinueTimer.start()
		elif current_index == 1:
			if not option_pressed:
				option_pressed = true
				$OptionAccepted.play()
				end_anim.play("blink")
				$EndTimer.start()

func update():
	for i in range(options.size()):
		if i == current_index:
			options[i].label_settings.font_color = Color(1, 1, 1)
		else:
			options[i].label_settings.font_color = Color(0.5, 0.5, 0.5)


func _on_continue_timer_timeout():
	get_tree().change_scene_to_file(Global.prev_scene)


func _on_end_timeout():
	get_tree().change_scene_to_file("res://Scenes/main_menu_screen.tscn")
