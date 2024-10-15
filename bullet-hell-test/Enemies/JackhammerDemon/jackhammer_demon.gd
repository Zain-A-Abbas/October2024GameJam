extends Enemy

const SIGN_BULLET = preload("res://Bullets/SignBullet.tres")
const BULLET_COOLDOWN: float = 3.0
const MOVE_RANGE: Vector2 = Vector2(52, 72)
const BULLET_COUNT: int = 8
var bullet_cooldown: float = 0.0
var is_cooldown: bool = false
var pos_tracker: float = 0.0
var start_position: Vector2 = Vector2.ZERO

func enemy_process(delta: float):
	super(delta)
	if start_position == Vector2.ZERO:
		start_position = position 
	pos_tracker += delta
	position.x = start_position.x + MOVE_RANGE.x * sin(pos_tracker * 0.9)
	position.y = start_position.y + MOVE_RANGE.y * sin(pos_tracker * 1.4)
	if is_cooldown:
		bullet_cooldown += delta
		if bullet_cooldown >= BULLET_COOLDOWN:
			is_cooldown = false
	match state:
		"Start":
			state = "Fight"
		"Fight":
			if time >= 0.5:
				time = 0.0
				state = "Sign"
				return
		"Sign":
			if is_cooldown:
				return
			is_cooldown = true
			bullet_cooldown = 0
			for i in BULLET_COUNT:
				bullet_manager.spawn_bullet(position, SIGN_BULLET, {"speed_mod": randf_range(0.5, 1.0), "rotation": position.angle_to_point(player.position) * randf_range(0.8, 1.2)})
				await Util.timer(0.075)
