extends CharacterBody2D

var speed = 90.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 8
@export var facing_left = true
var is_dying = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var floor_ray_cast = $FloorRayCast
@onready var wall_ray_cast = $WallRayCast
@onready var hit_box_collision_shape_2d = $HitBox/CollisionShape2D

func _ready():
	add_to_group("Enemy")
	if !facing_left:
		animated_sprite_2d.flip_h = true
		speed = -abs(speed)
		wall_ray_cast.target_position = Vector2(16, 0)
		floor_ray_cast.position = Vector2(4, 0)
	
func _physics_process(delta):
	if is_dying:
		hit_box_collision_shape_2d.disabled = true
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if (not floor_ray_cast.is_colliding() or wall_ray_cast.is_colliding()) and is_on_floor():
		flip()
	
	velocity.x = -speed
	
	move_and_slide()

func flip():
	facing_left = !facing_left
	
	if facing_left:
		animated_sprite_2d.flip_h = false
		speed = abs(speed)
		wall_ray_cast.target_position = Vector2(-6, 0)
		floor_ray_cast.position = Vector2(-4, 0)
	else:
		animated_sprite_2d.flip_h = true
		speed = -abs(speed)
		wall_ray_cast.target_position = Vector2(16, 0)
		floor_ray_cast.position = Vector2(4, 0)

func kill():
	is_dying = true
	$Explosion.play()
	animated_sprite_2d.play("kill")
	await animated_sprite_2d.animation_finished
	Global.drop_item(global_position)
	queue_free()
	
func _on_hit_box_body_entered(body):
	if body.is_in_group("Player") and !is_dying:
		body.kill_player_enemy()


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


func _on_visible_on_screen_notifier_2d_screen_exited():
	if get_tree().current_scene.name == "Stage3":
		queue_free()
