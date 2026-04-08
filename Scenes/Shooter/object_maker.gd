extends Node2D


const OBJECT_SCENES: Dictionary[Constants.ObjectType, PackedScene] = {
	Constants.ObjectType.BULLET_PLAYER: preload("res://Scenes/Bullets/player_bullet.tscn"),
	Constants.ObjectType.BULLET_ENEMY: preload("res://Scenes/Bullets/enemy_bullet.tscn"),
	Constants.ObjectType.EXPLOSION: preload("res://Scenes/EnemyBase/explosion.tscn"),
	Constants.ObjectType.PICKUP: preload("res://Scenes/FruitPickup/fruit_pickup.tscn")
	}


func _enter_tree() -> void:
	SignalHub.on_create_bullet.connect(on_create_bullet_emit)
	SignalHub.on_create_object.connect(on_create_object_emit)
	
	
func on_create_bullet_emit(pos: Vector2, dir: Vector2, speed: float, ob_type: Constants.ObjectType) -> void:
	if OBJECT_SCENES.has(ob_type) == false:
		return
	var nb: Bullet = OBJECT_SCENES[ob_type].instantiate()
	nb.setup(pos, dir, speed)
	call_deferred("add_child", nb)

func on_create_object_emit(pos: Vector2, ob_type: Constants.ObjectType) -> void:
	if OBJECT_SCENES.has(ob_type) == false:
		return
	var new_obj: Node2D = OBJECT_SCENES[ob_type].instantiate()
	new_obj.global_position = pos
	call_deferred("add_child", new_obj)
