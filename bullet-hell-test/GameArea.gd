extends Node2D

const GAME_SIZE: Vector2 = Vector2(720, 840)

@onready var enemies: Node = $Enemies
@onready var player: Player = $Player
@onready var enemy_bullets: BulletManager = $EnemyBullets

func spawn_enemy(enemy: PackedScene, spawn_position: Vector2, args: Dictionary = {}):
	var new_enemy: Enemy = enemy.instantiate()
	enemies.add_child(new_enemy)
	new_enemy.initialize(spawn_position, enemy_bullets, player, args)

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	spawn_enemy(load("res://Enemies/Demon/DemonEnemy.tscn"), Vector2(30, -64))
	spawn_enemy(load("res://Enemies/Demon/DemonEnemy.tscn"), Vector2(GAME_SIZE.x - 30, -64), {"flip_x": -1})
