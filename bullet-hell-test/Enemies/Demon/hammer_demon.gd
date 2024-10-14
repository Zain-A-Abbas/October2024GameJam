extends Enemy

const HAMMER_BULLET = preload("res://Bullets/HammerBullet.tres")
const MOVE_RANGE: Vector2 = Vector2(128, 240)
var start_pos: Vector2
var pos_tracker: float = 0.0


func enemy_process(delta: float):
	super(delta)
	match state:
		"Start":
			start_pos = position
			state = "Fight"
		"Fight":
			if time >= 1.0:
				time = 0.0
				bullet_manager.spawn_bullet(position, HAMMER_BULLET, {"rotation": position.angle_to_point(player.position)})
			position.x = start_pos.x + abs(sin(pos_tracker)) * MOVE_RANGE.x * flip_x
			position.y = start_pos.y + abs(sin(pos_tracker * 2)) * MOVE_RANGE.y
			pos_tracker += delta * 0.64
