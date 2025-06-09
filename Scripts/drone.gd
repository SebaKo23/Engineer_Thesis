extends CharacterBody2D

signal death

var speed = randi_range(65, 85)
var target : CharacterBody2D
var health = 6
var is_dying = false
var player_lockon = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hit_box_collision_shape_2d = $HitBox/CollisionShape2D
@onready var navigation_agent_2d = $NavigationAgent2D

func _ready():
	add_to_group("Enemy")
	set_physics_process(false)
	hit_box_collision_shape_2d.disabled = true
	modulate.a = 0.3
	target = get_tree().get_nodes_in_group("Player")[0]
	
func _process(_delta):
	if is_dying:
		hit_box_collision_shape_2d.disabled = true
	
func _physics_process(_delta):
	if is_dying:
		return
	var next_path_pos = navigation_agent_2d.get_next_path_position()
	var dir = global_position.direction_to(next_path_pos)
	velocity = dir * speed
	move_and_slide()

func create_path():
	navigation_agent_2d.target_position = target.global_position
	
func kill():
	is_dying = true
	emit_signal("death")
	$Explosion.play()
	animated_sprite_2d.play("kill")
	await animated_sprite_2d.animation_finished
	Global.drop_item(global_position)
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
				kill()
		else:
			if health > 2:
				$Damage.play()
				health -= 2
				area.destroy_bullet()
			else:
				area.destroy_bullet()
				kill()


func _on_hit_box_body_entered(body):
	if body.is_in_group("Player") and !is_dying and !target.is_invincible and !target.is_dying:
		body.kill_player_enemy()
		kill()


func _on_timer_timeout():
	create_path()


func _on_attack_zone_body_entered(body):
	if body.is_in_group("Player"):
		if !player_lockon:
			$DroneTrack.play()
			set_physics_process(true)
			hit_box_collision_shape_2d.call_deferred("set_disabled", false)
			modulate.a = 1
			player_lockon = true
