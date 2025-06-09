extends CanvasLayer

@onready var rest_text = $Control/Rests/RestText
@onready var xp_text = $Control/XP/XPText

func _process(_delta):
	rest_text.text = ": " + str(Global.rests)
	xp_text.text = ": " + str(Global.xp)
	if Global.xp < 5:
		xp_text.label_settings.font_color = Color(255, 255, 255)
	else:
		xp_text.label_settings.font_color = Color(0.361, 0.678, 1)
