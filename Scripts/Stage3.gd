extends Node2D

var enemy_preload = preload("res://Scenes/guard_dog.tscn") 
@onready var boss = $Boss
 
func _ready():
	Global.spawn_dogs = false
	Global.prev_scene = get_tree().current_scene.scene_file_path
	MusicManager.playing_stage_music = true
	MusicManager.manage_stage_music()

func _process(_delta):
	$SpawnTimer.wait_time = randf_range(1.0, 2.0)
	if not boss:
		boss_defeated()
	
func boss_defeated():
	set_process(false)
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.timeout.connect(_on_victory_timeout)
	add_child(timer)
	timer.start()
	
func spawn_enemy():
	var camera_pos = $GameCamera.global_position
	var view = get_viewport_rect().size / 2
	var left_edge = camera_pos.x - view.x
	var right_edge = camera_pos.x + view.x
	var direction = randi() % 2
	var spawn_position = Vector2()
	
	if direction == 0:
		spawn_position = Vector2(left_edge, 88)
	else:
		spawn_position = Vector2(right_edge, 88)
	
	var enemy = enemy_preload.instantiate()
	enemy.position = spawn_position
	enemy.speed = randi_range(75, 105)
	if direction == 0:
		enemy.facing_left = false
	get_parent().call_deferred("add_child", enemy)
	

func _on_spawn_timer_timeout():
	if Global.spawn_dogs:
		spawn_enemy()

func _on_victory_timeout():
	$Victory.play()
	await $Victory.finished
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/final_screen.tscn")


func _on_limit_boundaries_safezone():
	Global.spawn_dogs = true
