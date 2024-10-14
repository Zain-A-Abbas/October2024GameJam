extends Enemy

const CROSS_BULLET = preload("res://Bullets/CrossBullet.tres")
const SIGN_BULLET = preload("res://Bullets/SignBullet.tres")
const NAIL_BULLET = preload("res://Bullets/NailBullet.tres")
const SAW_BULLET = preload("res://Bullets/SawBullet.tres")

const SUPER_DRILL_COOLDOWN: float = 0.01
const SUPER_DRILL_DURATION: float = 16.0

const DRILL_COOLDOWN: float = 0.05
const DRILL_DURATION: float = 8.0


const SIGN_COOLDOWN: float = 3.0
const SIGN_COUNT: int = 25
const SIGN_DURATION: float = 8.0

const CROSS_COOLDOWN: float = 2.0
const CROSS_DURATION: float = 8.0

const MOVE_RANGE: Vector2 = Vector2(256, 256)
const DRILL_MOVE_RANGE: Vector2 = Vector2(96, 48)

const SAW_COOLDOWN: float = 100.0
const SAW_DURATION: float = 100.0
const SAW_ANGLE_OFFSETS: Array[int] = [-40, -20, 0, 20, 40]

const PHASES: Array[String] = [
	"Drill",
	"Super Drill",
	"Sign",
	"Cross Barrage",
	"Saw Wave"
]

var start_position: Vector2 = Vector2.ZERO

var move_to: Vector2 = Vector2.ZERO

var pos_tracker: float = 0.0

var bullet_angle: float = 0.0
var bullet_cooldown: float = 0.0
var current_cooldown: float = 0.0
var current_duration: float = 0.0
var is_cooldown: bool = false
var frame_count: int = 0
var can_move: bool = true
var can_phase_change: bool = true

func _ready() -> void:
	active = false
	super()
	await Util.timer(3.0)
	active = true

func enemy_process(delta: float):
	super(delta)
	frame_count += 1
	
	if start_position == Vector2.ZERO:
		start_position = position 
	pos_tracker += delta
	if is_cooldown:
		bullet_cooldown += delta
		if bullet_cooldown >= current_cooldown:
			is_cooldown = false
	
	if can_move:
		if state == "None":
			position.x = start_position.x + DRILL_MOVE_RANGE.x * sin(pos_tracker * 1.2)
			position.y = start_position.y + DRILL_MOVE_RANGE.y * sin(pos_tracker * 0.8)
			return
	
	if time >= current_duration && can_phase_change:
		cycle_phase()
		return
	
	match state:
		"Start":
			cycle_phase()
			return
		"Drill":
			position.x = start_position.x + DRILL_MOVE_RANGE.x * sin(pos_tracker * 1.2)
			position.y = start_position.y + DRILL_MOVE_RANGE.y * sin(pos_tracker * 0.8)
			
			if is_cooldown:
				return
			
			bullet_manager.spawn_bullet(position, NAIL_BULLET, {"rotation": bullet_angle})
			bullet_manager.spawn_bullet(position, NAIL_BULLET, {"rotation": bullet_angle + 1 * (PI / 2), "speed_mod": 0.7})
			bullet_manager.spawn_bullet(position, NAIL_BULLET, {"rotation": bullet_angle + 2 * (PI / 2)})
			bullet_manager.spawn_bullet(position, NAIL_BULLET, {"rotation": bullet_angle + 3 * (PI / 2), "speed_mod": 0.7})
			bullet_angle += delta * 16
			is_cooldown = true
			bullet_cooldown = 0
			
		"Super Drill":
			position.x = start_position.x + DRILL_MOVE_RANGE.x * sin(pos_tracker * 1.2)
			position.y = start_position.y + DRILL_MOVE_RANGE.y * sin(pos_tracker * 0.8)
			
			if is_cooldown:
				return
			
			
			if frame_count % 3 == 0:
				bullet_manager.spawn_bullet(position, NAIL_BULLET, {"rotation": bullet_angle})
				bullet_manager.spawn_bullet(position, NAIL_BULLET, {"rotation": bullet_angle + 1 * (PI / 2)})
				bullet_manager.spawn_bullet(position, NAIL_BULLET, {"rotation": bullet_angle + 2 * (PI / 2)})
				bullet_manager.spawn_bullet(position, NAIL_BULLET, {"rotation": bullet_angle + 3 * (PI / 2)})
			
			if time <= 5.0:
				bullet_angle += delta * 2.0
			elif time <= 10.0:
				bullet_angle -= delta * 2.0
			else:
				bullet_angle += delta * 2.0
			is_cooldown = true
			
			bullet_cooldown = 0
			
		"Sign":
			position.x = start_position.x + DRILL_MOVE_RANGE.x * sin(pos_tracker * 1.2)
			position.y = start_position.y + DRILL_MOVE_RANGE.y * sin(pos_tracker * 0.8)
			
			if is_cooldown:
				return
			is_cooldown = true
		
			bullet_cooldown = 0
			for i in SIGN_COUNT:
				bullet_manager.spawn_bullet(position, SIGN_BULLET, {"speed_mod": randf_range(0.5, 1.0), "rotation": position.angle_to_point(player.position) * randf_range(0.7, 1.3)})
				await Util.timer(0.075)
		
		"Cross Barrage":
			position.x = start_position.x + DRILL_MOVE_RANGE.x * sin(pos_tracker * 1.2)
			position.y = start_position.y + DRILL_MOVE_RANGE.y * sin(pos_tracker * 0.8)
			
			if is_cooldown:
				return
			is_cooldown = true
			bullet_cooldown = 0.0
			
			var cross_count: int = 8
			for i in cross_count:
				bullet_manager.spawn_bullet(Vector2(0, 200 * sqrt(cross_count / 4)).rotated(i * PI * 2 / cross_count), CROSS_BULLET)
				await Util.timer(0.2)
		
		"Saw Wave":
			position = position.move_toward(move_to, delta * 350)
			if is_cooldown:
				return
			is_cooldown = true
			bullet_cooldown = 0.0
			can_phase_change = false
			saw_wave()

func saw_wave():
	while (position != move_to):
		await get_tree().physics_frame
	await Util.timer(0.1)
	var wave_count: int = 4
	var attack_count: int = 2
	
	await saw_wave_fire(attack_count, wave_count)
	
	await Util.timer(0.5)
	move_to = Vector2(720 - move_to.x, move_to.y)
	
	while (position != move_to):
		await get_tree().physics_frame
	await Util.timer(0.1)
	
	await saw_wave_fire(attack_count, wave_count)
	
	await Util.timer(0.8)
	can_phase_change = true
	cycle_phase()

func saw_wave_fire(attack_count: int, wave_count: int):
	for i in attack_count:
		for j in wave_count:
			var angle_to_player: float = position.angle_to_point(player.position)
			for angle in SAW_ANGLE_OFFSETS:
				bullet_manager.spawn_bullet(position, SAW_BULLET, {"rotation": angle_to_player + deg_to_rad(angle), "size_mod": 2.5, "speed_mod": 2.5})
			await Util.timer(0.1)
		await Util.timer(0.7)

func cycle_phase():
	SE.sound_effect("PhaseCycle")
	state = "None"
	time = 0.0
	await Util.timer(2.0)
	change_state(PHASES.pick_random())


func change_state(new_state: String):
	is_cooldown = false
	bullet_cooldown = 0.0
	state = new_state
	match state:
		"Drill":
			current_cooldown = DRILL_COOLDOWN
			current_duration = DRILL_DURATION
		"Super Drill":
			current_cooldown = SUPER_DRILL_COOLDOWN
			current_duration = SUPER_DRILL_DURATION
		"Sign":
			current_cooldown = SIGN_COOLDOWN
			current_duration = SIGN_DURATION
		"Cross Barrage":
			current_cooldown = CROSS_COOLDOWN
			current_duration = CROSS_DURATION
		"Saw Wave":
			current_cooldown = SAW_COOLDOWN
			current_duration = SAW_DURATION
			move_to = Vector2(720 * 0.2, 840 * 0.2)
