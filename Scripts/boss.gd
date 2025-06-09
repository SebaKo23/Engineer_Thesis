extends Node2D


var health = 120
var spawn_limit = 20
var spawned_drones = 0
var is_dying = false
var drone_preload = preload("res://Scenes/drone.tscn")
var camera_pos
var is_spawning = false
var boss_music_started = false
var enemies
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hit_box_collision_shape_2d = $HitBox/CollisionShape2D
@onready var spawn_timer = $DroneSpawnTimer

func _ready():
	add_to_group("Enemy")
	hit_box_collision_shape_2d.disabled = true
	camera_pos = $"../GameCamera".global_position

func _process(_delta):
	enemies = get_tree().get_nodes_in_group("Enemy")
	if is_dying:
		hit_box_collision_shape_2d.disabled = true
		return
	if camera_pos.x < 3680:
		camera_pos = $"../GameCamera".global_position
	else:
		Global.spawn_dogs = false
		var spawn_time = randi_range(3, 5)
		if not is_spawning:
			is_spawning = true
			hit_box_collision_shape_2d.disabled = false
			spawn_timer.start(spawn_time)
		if not boss_music_started:
			boss_music_started = true
			MusicManager.music_player.stop()
			$Battle.play()

func spawn_drones():
	var drone_spawner = $DroneSpawner
	var drone = drone_preload.instantiate()
	drone.position = drone_spawner.global_position
	drone.death.connect(_on_drone_death)
	drone.get_node("AttackZone/CollisionShape2D").scale = Vector2(30, 30)
	get_parent().call_deferred("add_child", drone)
	
func kill():
	$Battle.stop()
	is_dying = true
	$SoundDelayTimer.start()
	$Explosion.play()
	animated_sprite_2d.play("kill")
	await animated_sprite_2d.animation_finished
	queue_free()

func _on_hit_box_area_entered(area):
	if area.is_in_group("TinyBullet") or area.is_in_group("Bullet"):
		if area.is_in_group("TinyBullet"):
			if health > 1:
				$Damage.play()
				health -= 1
				area.destroy_bullet()
			else:
				area.destroy_bullet()
				for enemy in enemies:
					enemy.kill()
		else:
			if health > 2:
				$Damage.play()
				health -= 2
				area.destroy_bullet()
			else:
				area.destroy_bullet()
				for enemy in enemies:
					enemy.kill()


func _on_drone_spawn_timer_timeout():
	if !is_dying and spawned_drones < spawn_limit:
		spawned_drones += 1
		$DroneSpawn.play()
		spawn_drones()
		is_spawning = false

func _on_drone_death():
	spawned_drones -= 1
	
func _on_sound_delay_timer_timeout():
	$Explosion.play()


func _on_battle_finished():
	$Battle.play()
