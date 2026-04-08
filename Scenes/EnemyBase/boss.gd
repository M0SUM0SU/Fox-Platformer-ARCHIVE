extends Node2D

@export var _invincible: bool = false
@export var lives: int = 5
@export var points: int = 5

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hitbox: Area2D = $Visuals/Hitbox
@onready var shooter: Shooter = $Visuals/Shooter
@onready var sm: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var visuals: Node2D = $Visuals



func _ready() -> void:
	pass


func activate_collisions() -> void:
	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("monitorable", true)

func lose_lives() -> void:
	lives -= 1
	if lives <= 0:
		SignalHub.on_scored_emit(points)
		SignalHub.on_boss_killed_emit()
		queue_free()


func take_damage() -> void:
	if _invincible == true:
		return
	
	_invincible = true
	sm.travel("Hit")
	tween_hit()
	lose_lives()

func tween_hit() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(visuals, "position", Vector2.ZERO, 1)


func _on_trigger_area_entered(area: Area2D) -> void:
	animation_tree["parameters/conditions/on_trigger"] = true

func shoot_boss()-> void:
	shooter.shoot_at_player()


func _on_hitbox_area_entered(area: Area2D) -> void:
	take_damage()
