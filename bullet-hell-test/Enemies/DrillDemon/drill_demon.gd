extends Enemy

const NAIL_BULLET = preload("res://Bullets/NailBullet.tres")
const BULLET_COOLDOWN: float = 0.075
const MOVE_RANGE: Vector2 = Vector2(64, 64)
var bullet_angle: float = 0.0
var bullet_cooldown: float = 0.0
var is_cooldown: bool = false
var pos_tracker: float = 0.0
var start_position: Vector2 = Vector2.ZERO
var spin_direction: int = 1

func initialize(spawn_position: Vector2, _bullet_manager: BulletManager, _player: Player, args: Dictionary = {}):
	super(spawn_position, _bullet_manager, _player, args)
	if args.has("spin_direction"):
		spin_direction = args["spin_direction"]

func enemy_process(delta: float):
	if start_position == Vector2.ZERO:
		start_position = position 
	pos_tracker += delta
	position.x = start_position.x + MOVE_RANGE.x * sin(pos_tracker * 1.2)
	position.y = start_position.y + MOVE_RANGE.y * sin(pos_tracker * 0.8)
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
				state = "Drill"
				bullet_angle = -PI / 2
				return
		"Drill":
			if is_cooldown:
				return
			bullet_manager.spawn_bullet(position, NAIL_BULLET, {"rotation": bullet_angle})
			bullet_angle += delta * 16 * spin_direction
			is_cooldown = true
			bullet_cooldown = 0
