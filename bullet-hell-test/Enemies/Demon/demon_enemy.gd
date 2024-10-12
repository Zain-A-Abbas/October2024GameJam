extends Enemy

const BASE_BULLET = preload("res://Bullets/BaseBullet.tres")
const MOVE_RANGE: Vector2 = Vector2(128, 240)
var start_pos: Vector2
var pos_tracker: float = 0.0


func enemy_process(delta: float):
	match state:
		"Start":
			position += Vector2(0, speed) * delta
			if time >= 1.0:
				state = "Fight"
				start_pos = position
		"Fight":
			if time >= 1.0:
				time = 0.0
				bullet_manager.spawn_bullet(position, BASE_BULLET, {"rotation": position.angle_to_point(player.position)})
			position.x = start_pos.x + abs(sin(pos_tracker)) * MOVE_RANGE.x * flip_x
			position.y = start_pos.y + abs(sin(pos_tracker * 2)) * MOVE_RANGE.y
			pos_tracker += delta * 0.64
