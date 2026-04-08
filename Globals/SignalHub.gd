extends Node

signal on_create_bullet(pos: Vector2, dir: Vector2, speed: float, ob_type: Constants.ObjectType)
signal on_create_object(pos: Vector2, ob_type: Constants.ObjectType)
signal on_scored_points(points: int)
signal on_boss_killed
signal on_player_hit(lives: int, shake: bool)
signal on_level_complete(complete: bool)


func on_create_bullet_emit(pos: Vector2, dir: Vector2, speed: float, ob_type: Constants.ObjectType) -> void:
	on_create_bullet.emit(pos, dir, speed, ob_type)

func on_create_object_emit(pos: Vector2, ob_type: Constants.ObjectType):
	on_create_object.emit(pos, ob_type)

func on_scored_emit(points: int) -> void:
	on_scored_points.emit(points)

func on_boss_killed_emit() -> void:
	on_boss_killed.emit()

func on_player_hit_emit(lives: int, shake: bool) -> void:
	on_player_hit.emit(lives, shake)

func on_level_complete_emit(complete: bool):
	on_level_complete.emit(complete)
