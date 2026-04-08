extends Area2D


@export var points: int = 2

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound: AudioStreamPlayer2D = $Sound


func _ready() -> void:
	var ln: Array[String] = []
	for an_name in anim.sprite_frames.get_animation_names():
		ln.push_back(an_name)
	anim.animation = ln.pick_random()
	anim.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	hide()
	set_deferred("monitoring", false)
	sound.play()
	SignalHub.on_scored_points.emit(points)

func _on_sound_finished() -> void:
	queue_free()
