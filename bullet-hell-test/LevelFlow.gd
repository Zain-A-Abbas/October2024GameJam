extends Node

signal enemies_cleared
@onready var game_area: Node2D = $".."

const GAME_SIZE: Vector2 = Vector2(720, 840)
const SAW_DEMON = preload("res://Enemies/SawDemon/SawDemon.tscn")
const DRILL_DEMON = preload("res://Enemies/DrillDemon/DrillDemon.tscn")
const HAMMER_DEMON = preload("res://Enemies/Demon/HammerDemon.tscn")

var enemies_to_kill: int = 0
var enemies_killed: int = 0

func level():
	spawn_enemy(HAMMER_DEMON, Vector2(GAME_SIZE.x * 0.4, 128))
	await enemies_cleared
	await Util.timer(0.4)
	spawn_enemy(DRILL_DEMON, Vector2(128, 128))
	spawn_enemy(DRILL_DEMON, Vector2(GAME_SIZE.x - 128, 128), {"spin_direction": -1})
	await enemies_cleared
	await Util.timer(0.4)
	spawn_enemy(SAW_DEMON, Vector2(GAME_SIZE.x * 0.5, GAME_SIZE.y * 0.2))
	await enemies_cleared
	await Util.timer(0.4)
	spawn_enemy(SAW_DEMON, Vector2(GAME_SIZE.x * 0.3, GAME_SIZE.y * 0.2))
	spawn_enemy(SAW_DEMON, Vector2(GAME_SIZE.x * 0.7, GAME_SIZE.y * 0.2), {"flip_x": -1})
	await enemies_cleared
	await Util.timer(0.4)
	spawn_enemy(SAW_DEMON, Vector2(GAME_SIZE.x * 0.2, GAME_SIZE.y * 0.2))
	spawn_enemy(SAW_DEMON, Vector2(GAME_SIZE.x * 0.8, GAME_SIZE.y * 0.2), {"flip_x": -1})
	spawn_enemy(DRILL_DEMON, Vector2(GAME_SIZE.x * 0.5, GAME_SIZE.y * 0.3))
	await enemies_cleared
	print("BNB")

func reset_kill_count():
	enemies_to_kill = 0

func spawn_enemy(enemy: PackedScene, spawn_position: Vector2, args: Dictionary = {}):
	enemies_to_kill += 1
	game_area.spawn_enemy(enemy, spawn_position, args)

func enemy_death():
	enemies_killed += 1
	if enemies_killed == enemies_to_kill:
		enemies_to_kill = 0
		enemies_killed = 0
		emit_signal("enemies_cleared")
