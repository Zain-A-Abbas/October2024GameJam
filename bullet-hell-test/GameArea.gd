extends Node2D

const GAME_SIZE: Vector2 = Vector2(720, 840)
const POINT_REWARD = preload("res://PointReward.tscn")

@onready var level_flow: Node = $LevelFlow
@onready var enemies: Node = $Enemies
@onready var player: Player = $Player
@onready var enemy_bullets: BulletManager = $EnemyBullets
@onready var enemy_death_sprite: AnimatedSprite2D = $EnemyDeathSprite
@onready var enemy_spawn_sprite: AnimatedSprite2D = $EnemySpawnSprite
@onready var impact_frame: Sprite2D = $ImpactFrame
@onready var screen_shake: TraumaComponent = $ScreenShake

func initialize():
	EventBus.enemy_killed.connect(enemy_death)
	player.controllable = true
	await Util.timer(1.0)
	level_flow.level()

func bomb():
	impact_frame.material.set_shader_parameter("impact", true)
	process_mode = PROCESS_MODE_DISABLED
	await Util.timer(0.1)
	impact_frame.material.set_shader_parameter("impact", false)
	process_mode = PROCESS_MODE_INHERIT
	screen_shake.begin_trauma(20, 40)
	enemy_bullets.clear_bullets()
	for enemy in enemies.get_children():
		if is_instance_of(enemy, Enemy):
			enemy.enemy_hurt(25 + 75 * int(!enemy.boss), true)

func spawn_enemy(enemy: PackedScene, spawn_position: Vector2, args: Dictionary = {}):
	var new_enemy: Enemy = enemy.instantiate()
	enemies.add_child(new_enemy)
	new_enemy.initialize(spawn_position, enemy_bullets, player, args)
	enemy_spawn_anim(spawn_position)

func enemy_death(enemy_position: Vector2):
	level_flow.enemy_death()
	enemy_death_anim(enemy_position)
	call_deferred("enemy_point_reward", enemy_position)

func enemy_point_reward(point_position: Vector2):
	for x in 3:
		var new_point_reward: PointReward = POINT_REWARD.instantiate()
		new_point_reward.points = randi_range(1, 3)
		add_child(new_point_reward)
		new_point_reward.position = point_position + Vector2(randi_range(-10, 10), randi_range(-10, 10))

func enemy_death_anim(anim_position: Vector2):
	var new_death_sprite: AnimatedSprite2D = enemy_death_sprite.duplicate()
	add_child(new_death_sprite)
	new_death_sprite.position = anim_position
	new_death_sprite.play("default")
	new_death_sprite.animation_finished.connect(new_death_sprite.queue_free)

func enemy_spawn_anim(anim_position: Vector2):
	var new_spawn_sprite: AnimatedSprite2D = enemy_spawn_sprite.duplicate()
	add_child(new_spawn_sprite)
	new_spawn_sprite.position = anim_position
	new_spawn_sprite.play("default")
	new_spawn_sprite.animation_finished.connect(new_spawn_sprite.queue_free)
