extends Node2D
class_name Enemy

@onready var enemy_sprite: Sprite2D = $EnemySprite

@export var hp: int = 10
@export var speed: float = 150

var time: float = 0.0
var bullet_manager: BulletManager
var player: Player
var state: String = "Start"
var flip_x: int = 1

func initialize(spawn_position: Vector2, _bullet_manager: BulletManager, _player: Player, args: Dictionary = {}):
	position = spawn_position
	bullet_manager = _bullet_manager
	player = _player
	if args.has("flip_x"):
		flip_x = args["flip_x"]

func _physics_process(delta: float) -> void:
	time += delta
	enemy_process(delta)

func enemy_process(delta: float):
	pass
