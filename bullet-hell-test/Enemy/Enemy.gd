extends Node2D
class_name Enemy

signal hp_update(new_hp: int)

@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var hurtbox: Area2D = $Hurtbox

@export var hp: int = 25
@export var speed: float = 150

var time: float = 0.0
var bullet_manager: BulletManager
var player: Player
var state: String = "Start"
var flip_x: int = 1
var boss: bool = false
var active: bool = true
var killed: bool = false

var damage_tween: Tween

func _ready() -> void:
	var spawn_tween: Tween = create_tween()
	spawn_tween.tween_property(
		self,
		"modulate:a",
		1.0,
		0.5
	).from(0.0)

func initialize(spawn_position: Vector2, _bullet_manager: BulletManager, _player: Player, args: Dictionary = {}):
	if !args.has("boss"):
		if Game.run_seconds >= 90:
			hp *= 3
		elif Game.run_seconds >= 30:
			hp *= 2
	position = spawn_position
	bullet_manager = _bullet_manager
	player = _player
	if args.has("flip_x"):
		flip_x = args["flip_x"]

func _physics_process(delta: float) -> void:
	time += delta
	if player.alive && active:
		enemy_process(delta)

func enemy_process(_delta: float):
	pass

func enemy_hurt(damage: int = 1, bomb: bool = false):
	SE.sound_effect("EnemyHit", 0.05)
	hp -= damage
	emit_signal("hp_update", hp)
	if !bomb:
		player.gain_points(damage)
	if hp <= 0:
		enemy_die()
		return
	if damage_tween:
		damage_tween.custom_step(1000)
		damage_tween.kill()
	damage_tween = create_tween()
	damage_tween.tween_method(hurt_blink, 1.0, 0.0, 0.1)

func enemy_die():
	if killed:
		return
	SE.sound_effect("Death")
	EventBus.emit_signal("enemy_killed", position)
	killed = true
	queue_free()

func hurt_blink(value: float):
	enemy_sprite.material.set_shader_parameter("hurt", value)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	enemy_hurt()
	area.get_parent().bullet_hit()
