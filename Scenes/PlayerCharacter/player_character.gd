extends CharacterBody2D

class_name Player

const JUMP = preload("res://assets/sound/jump.wav")
const DAMAGE = preload("res://assets/sound/damage.wav")

@export var fell_off_y: float = 100.0
@export var lives: int = 5
@export var camera_min: Vector2 = Vector2(-10000, 10000)
@export var camera_max: Vector2 = Vector2(10000, -10000)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel
@onready var shooter: Shooter = $Shooter
@onready var sound: AudioStreamPlayer2D = $sound
@onready var hurt: Timer = $Hurt
@onready var player_cam: Camera2D = $PlayerCam

const GRAVITY: float = 690.0
const JUMP_SPEED: float = -270.0
const RUN_SPEED: float = 120.0
const MAX_FALL: float = 350.0
const HURT_JUMP_VELOCITY: Vector2 = Vector2(0, -130.0)

var movement: float = Input.get_axis("left", "right")
var _is_hurt: bool = false
var _invincible: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_camera_limits()
	call_deferred("late_init")

func set_camera_limits() -> void:
	player_cam.limit_bottom = camera_min.y
	player_cam.limit_top = camera_max.y
	player_cam.limit_left = camera_min.x
	player_cam.limit_right = camera_max.x

func late_init() -> void:
	SignalHub.on_player_hit_emit(lives, false)

func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") == true:
		var dir: Vector2 = Vector2.LEFT if sprite_2d.flip_h else Vector2.RIGHT
		shooter.shoot(dir)

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	
	get_input()
	
	velocity.y = clampf(velocity.y, JUMP_SPEED, MAX_FALL)
	
	move_and_slide()
	update_debug_label()
	fallen_off()

func play_effect(effect: AudioStream) -> void:
	sound.stop()
	sound.stream = effect
	sound.play()

func get_input() -> void:
	if _is_hurt == true:
		return
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED
		play_effect(JUMP)
	
	velocity.x = RUN_SPEED * Input.get_axis("left", "right")
	
	if not is_equal_approx(velocity.x, 0.0):
		sprite_2d.flip_h = velocity.x < 0

func update_debug_label() -> void:
	var ds: String = ""
	ds += "Floor: %s LV:%s\n" % [is_on_floor(), lives]
	ds += "V: %.1f,%.1f\n" % [velocity.x, velocity.y]
	ds += "P: %.1f,%.1f\n" % [global_position.x, global_position.y]
	debug_label.text = ds

func fallen_off() -> void:
	if global_position.y < fell_off_y:
		return
	reduce_lives(lives)

func apply_hit() -> void:
	
	if _invincible == true:
		return
	
	if reduce_lives(1) == false:
		return
	
	_invincible = true
	dmg_tween()
	apply_hurt_jump()

func dmg_tween() -> void:
	var tween: Tween = create_tween()
	
	for i in range(3):
		tween.tween_property(sprite_2d, "modulate", Color("#ffffff", 0.0), 0.2)
		tween.tween_property(sprite_2d, "modulate", Color("#ffffff", 1.0), 0.2)
		tween.tween_property(self, "_invincible", false, 0)

func reduce_lives(reduction: int) -> bool:
	lives -= reduction
	SignalHub.on_player_hit_emit(lives, true)
	if lives <= 0:
		set_physics_process(false)
		return false
	return true

func apply_hurt_jump() -> void:
	_is_hurt = true
	velocity = HURT_JUMP_VELOCITY
	hurt.start()
	play_effect(DAMAGE)

func _on_hitbox_area_entered(area: Area2D) -> void:
	call_deferred("apply_hit")


func _on_hurt_timeout() -> void:
	_is_hurt = false
