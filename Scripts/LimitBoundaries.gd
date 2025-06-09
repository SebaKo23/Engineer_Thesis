extends Node2D

signal safezone

var view 
var camera_pos
var player 

func _ready():
	view = get_viewport_rect().size / 2
	camera_pos = $"../GameCamera".global_position
	player = $"../Player"
	
func _process(_delta):
	if get_tree().current_scene.name == "Stage1":
		if camera_pos.x < 2080:
			camera_pos = $"../GameCamera".global_position
		else:
			pass
		var bound_l = camera_pos.x - view.x + 8
		var bound_r = camera_pos.x + view.x - 10
		if !player:
			pass
		else:
			player.global_position.x = clamp(player.global_position.x, bound_l, bound_r)
	
	if get_tree().current_scene.name == "Stage2":
		if camera_pos.x < 2470:
			camera_pos = $"../GameCamera".global_position
		else:
			pass
		var bound_l = camera_pos.x - view.x + 8
		var bound_r = camera_pos.x + view.x - 10
		if !player:
			pass
		else:
			player.global_position.x = clamp(player.global_position.x, bound_l, bound_r)

	if get_tree().current_scene.name == "Stage3":
		if camera_pos.x < 3680:
			camera_pos = $"../GameCamera".global_position
			if camera_pos.x >= 290 and camera_pos.x < 310:
				safezone.emit()
		else:
			pass
		var bound_l = camera_pos.x - view.x + 8
		var bound_r = camera_pos.x + view.x - 10
		if !player:
			pass
		else:
			player.global_position.x = clamp(player.global_position.x, bound_l, bound_r)
