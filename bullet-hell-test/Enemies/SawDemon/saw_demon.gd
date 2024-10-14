extends Enemy

const BULLET_ANGLE_OFFSETS: Array[int] = [-30, -15, 0, 15, 30]
const SAW_BULLET = preload("res://Bullets/SawBullet.tres")
const MOVE_RANGE: Vector2 = Vector2(128, 64)
var start_pos: Vector2
var pos_tracker: float = 0.0


func enemy_process(delta: float):
	super(delta)
	match state:
		"Start":
			state = "Fight"
			start_pos = position
		"Fight":
			if time >= 1.5:
				time = 0.0
				var angle_to_player: float = position.angle_to_point(player.position)
				for angle in BULLET_ANGLE_OFFSETS:
					bullet_manager.spawn_bullet(position, SAW_BULLET, {"rotation": angle_to_player + deg_to_rad(angle)})
			position.x = start_pos.x + sin(pos_tracker) * MOVE_RANGE.x * flip_x
			position.y = start_pos.y + sin(2 * pos_tracker) * MOVE_RANGE.y
			pos_tracker += delta * 0.64*2
