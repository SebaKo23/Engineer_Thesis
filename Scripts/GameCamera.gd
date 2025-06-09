extends Camera2D


var move_speed : float = 100.0
@export var level_limit_right : float
@export var level_limit_left : float
@export var player : CharacterBody2D

func _process(delta):
	if !player:
		pass
	else:
		var camera_x = global_position.x
		var player_x = player.global_position.x

		if player_x > camera_x:
			camera_x = lerp(camera_x, player_x, move_speed * delta)
		
		camera_x = clamp(camera_x, level_limit_left, level_limit_right)

		global_position.x = camera_x
