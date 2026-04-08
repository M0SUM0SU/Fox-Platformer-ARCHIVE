extends Node2D


const ENEMY_BULLET = preload("res://Scenes/Bullets/enemy_bullet.tscn")
const PLAYER_BULLET = preload("res://Scenes/Bullets/player_bullet.tscn")

@onready var music: AudioStreamPlayer = $Music

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("test"):
		var b = PLAYER_BULLET.instantiate()
		add_child(b)

func _ready() -> void:
	get_tree().paused = false
