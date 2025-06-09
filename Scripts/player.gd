extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var bullet_point = $BulletPoint

var speed : float = 75.0
var jump_velocity : float = -400.0
var air_control : float = 0.5
var gravity_scale : float = 1
var tiny_bullet = preload("res://Scenes/tiny_bullet.tscn")
var bullet = preload("res://Scenes/bullet.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_scale
var in_air = false
var is_invincible = false
var is_dying = false
var is_inside_goo = false
var is_pitfall_kill = false
var can_shoot = true
var last_direction = 1
var last_position : Vector2

func _ready():
	add_to_group("Player")
	
func _process(_delta):
	if is_inside_goo:
		kill_player_enemy()

func _physics_process(delta):
	if is_dying:
		return
		
	if is_on_floor() and global_position.distance_to(last_position) > 150:
		last_position = global_position
		
	if not is_on_floor():
		velocity.y += gravity * delta
		in_air = true
	else:
		in_air = false

	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_dying:
		$Sounds/Jump.play()
		velocity.y = jump_velocity

	var direction = Input.get_axis("left", "right")
	
	if direction > 0:
		sprite.flip_h = false
		last_direction = 1
		bullet_point.position.x = 10
	elif direction < 0:
		sprite.flip_h = true
		last_direction = -1
		bullet_point.position.x = -10
		
	if direction and !is_dying:
		if in_air:
			velocity.x = lerp(velocity.x, direction * speed, air_control)
		else:
			velocity.x = direction * speed
	else:
		if not in_air:
			velocity.x = move_toward(velocity.x, 0, speed)
			
	if Global.xp < 5:
		if Input.is_action_just_pressed("shoot") and !is_dying:
			shoot()
	else:
		if Input.is_action_pressed("shoot") and !is_dying:
			shoot()
			
	move_and_slide()
	
func shoot():
	if can_shoot:
		can_shoot = false
		if Global.xp < 5:
			var tiny_bullet_instance = tiny_bullet.instantiate()
			tiny_bullet_instance.direction = last_direction
			tiny_bullet_instance.global_position = bullet_point.get_global_position()
			get_parent().add_child(tiny_bullet_instance)
			$Sounds/TinyBulletSound.play()
			can_shoot = true
		else:
			var bullet_instance = bullet.instantiate()
			bullet_instance.direction = last_direction
			bullet_instance.global_position = bullet_point.get_global_position()
			get_parent().add_child(bullet_instance)
			$Sounds/BulletSound.play()
			$FireRateTimer.start()

func kill_player_enemy():
	if is_invincible or is_dying:
		return
	
	is_dying = true
	$Sounds/Explosion.play()
	sprite.play("kill")
	await sprite.animation_finished
	if Global.rests > 0:
		Global.rests -= 1
		reset_player()
	else:
		game_over()

func kill_player_pitfall():
	is_dying = true
	is_pitfall_kill = true
	if Global.rests > 0:
		Global.rests -= 1
		reset_player()
	else:
		game_over()
		
func game_over():
	if Global.continues >= 1:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/game_over_screen.tscn")
	else:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/game_over_screen_final.tscn")

func reset_player():
	global_position = last_position
	velocity = Vector2.ZERO
	sprite.play("default")
	is_dying = false
	if is_pitfall_kill == false:
		is_invincible = true
		modulate.a = 0.5
		$InvicibilityTime.start()
	is_pitfall_kill = false
	Global.xp = 0
	
func collect_item():
	if Global.xp < 4:
		$Sounds/CollectGem.play()
		Global.xp += 1
	elif Global.xp == 4:
		$Sounds/Upgrade.play()
		Global.xp += 1

func _on_invicibility_time_timeout():
	modulate.a = 1.0
	is_invincible = false


func _on_fire_rate_timer_timeout():
	can_shoot = true

func _on_hit_box_body_entered(_body):
	is_inside_goo = true

func _on_hit_box_body_exited(_body):
	is_inside_goo = false
