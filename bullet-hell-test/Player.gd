extends CharacterBody2D
class_name Player

@onready var game_area: Node2D = $".."
@onready var hurtbox: Area2D = $Hurtbox
@onready var point_attractor: Area2D = $PointAttractor
@onready var point_pickup: Area2D = $PointPickup
@onready var hitbox_sprite: Sprite2D = $HitboxSprite

const PLAYER_SPEED: float = 20000.0
const BULLET_COOLDOWN: float = 0.1
const PLAYER_BULLET = preload("res://Bullets/PlayerBullet.tres")

@export var bullet_manager: BulletManager
var controllable: bool = true
var cooldown_tracker: float = 0.0
var bullet_cooldown: bool = false

var level_tracker: int = 0
var bomb_tracker: int = 0
var level: int = 1

func _ready() -> void:
	hitbox_sprite.modulate.a = 0.0
	Game.player = self

func _physics_process(delta: float) -> void:
	if bullet_cooldown:
		cooldown_tracker += delta
		if cooldown_tracker >= BULLET_COOLDOWN:
			bullet_cooldown = false
			cooldown_tracker = 0.0
	if controllable:
		input(delta)
	move_and_slide()

func input(delta: float):
	if Input.is_action_just_pressed("bomb") && Game.bombs > -100:
		Game.bombs -= 1
		game_area.bomb()
		return
	
	var input_lr: float = Input.get_axis("ui_left", "ui_right")
	var input_ud: float = Input.get_axis("ui_up", "ui_down")
	
	if Input.is_action_pressed("slow"):
		velocity = Vector2(input_lr, input_ud).normalized() * PLAYER_SPEED * delta / 2
		hitbox_sprite.modulate.a = minf(1.0, hitbox_sprite.modulate.a + 0.08)
	else:
		velocity = Vector2(input_lr, input_ud).normalized() * PLAYER_SPEED * delta
		hitbox_sprite.modulate.a = maxf(0.0, hitbox_sprite.modulate.a - 0.08)
	
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	if bullet_cooldown:
		return
	match level:
		1:
			bullet_manager.spawn_bullet(shoot_position(), PLAYER_BULLET, {"rotation": -PI/2})
		2:
			bullet_manager.spawn_bullet(shoot_position() + Vector2(-10, 0), PLAYER_BULLET, {"rotation": -PI/2})
			bullet_manager.spawn_bullet(shoot_position() + Vector2(10, 0), PLAYER_BULLET, {"rotation": -PI/2})
		3:
			bullet_manager.spawn_bullet(shoot_position() + Vector2(-30, -10), PLAYER_BULLET, {"rotation": -PI/2})
			bullet_manager.spawn_bullet(shoot_position() + Vector2(-10, 0), PLAYER_BULLET, {"rotation": -PI/2})
			bullet_manager.spawn_bullet(shoot_position() + Vector2(10, 0), PLAYER_BULLET, {"rotation": -PI/2})
			bullet_manager.spawn_bullet(shoot_position() + Vector2(30, -10), PLAYER_BULLET, {"rotation": -PI/2})
	bullet_cooldown = true

func shoot_position() -> Vector2:
	return self.position + Vector2(0, -10)

func player_hit():
	visible = false
	hurtbox.set_deferred("monitoring", false)

func gain_points(points: int):
	Game.points += points
	bomb_tracker += points
	level_tracker += points
	if level_tracker >= 100 && level < 3:
		level_tracker -= 100
		level += 1
	if bomb_tracker >= 50 && Game.bombs < 3:
		bomb_tracker -= 50
		Game.bombs += 1

func _on_hurtbox_area_entered(area: Area2D) -> void:
	player_hit()
	area.get_parent().bullet_hit()


func _on_point_attractor_area_entered(area: Area2D) -> void:
	area.get_parent().player = self

func _on_point_pickup_area_entered(area: Area2D) -> void:
	area.get_parent().die()
