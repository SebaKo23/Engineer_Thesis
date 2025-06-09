extends Node

# Zmienne globalne
var rests : int = 3
var continues: int = 2
var xp : int = 0 
var drop_chance : float = 0.33
var pickup_scene = preload("res://Scenes/xp_gem.tscn") 
var prev_scene
var spawn_dogs = false


# Funkcja tworząca przedmiot doświadczenia z wrogów
func drop_item(position: Vector2):
	if randi() % 100 < int(drop_chance * 100) and xp < 5:
		var pickup = pickup_scene.instantiate()
		pickup.global_position = position
		get_parent().add_child(pickup)
