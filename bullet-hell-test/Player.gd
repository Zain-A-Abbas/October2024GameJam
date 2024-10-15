extends CharacterBody2D
class_name Player

@onready var game_area: Node2D = $".."
@onready var hurtbox: Area2D = $Hurtbox
@onready var point_attractor: Area2D = $PointAttractor
@onready var point_pickup: Area2D = $PointPickup
@onready var hitbox_sprite: Sprite2D = $HitboxSprite
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var hurt_anim: AnimatedSprite2D = $HurtAnim

const PLAYER_SPEED: float = 20000.0
const BULLET_COOLDOWN: float = 0.1
const PLAYER_BULLET = preload("res://Bullets/PlayerBullet.tres")
const GAME_REGION: Vector2 = Vector2(720, 840)

@export var bullet_manager: BulletManager
var controllable: bool = false
var cooldown_tracker: float = 0.0
var bullet_cooldown: bool = false

var level_tracker: int = 0
var life_tracker: int = 0
var bomb_tracker: int = 0
var level: int = 1
var alive: bool = true

# Coyote time
var bomb_safety: bool = false
var bomb_safety_wait: bool = false

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
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func input(delta: float):
	if Input.is_action_just_pressed("bomb") && Game.bombs > 0:
		Game.bombs -= 1
		SE.sound_effect("Bomb")
		activate_bomb_safety()
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

func activate_bomb_safety():
	bomb_safety = true
	await Util.timer(0.133)
	bomb_safety = false

func shoot():
	if bullet_cooldown:
		return

	SE.sound_effect("PlayerFire", 0.2)
	match level:
		1:
			bullet_manager.spawn_bullet(shoot_position(), PLAYER_BULLET, {"rotation": -PI/2}, false)
		2:
			bullet_manager.spawn_bullet(shoot_position() + Vector2(-10, 0), PLAYER_BULLET, {"rotation": -PI/2}, false)
			bullet_manager.spawn_bullet(shoot_position() + Vector2(10, 0), PLAYER_BULLET, {"rotation": -PI/2}, false)
		3:
			bullet_manager.spawn_bullet(shoot_position() + Vector2(-30, -10), PLAYER_BULLET, {"rotation": -PI/2}, false)
			bullet_manager.spawn_bullet(shoot_position() + Vector2(-10, 0), PLAYER_BULLET, {"rotation": -PI/2}, false)
			bullet_manager.spawn_bullet(shoot_position() + Vector2(10, 0), PLAYER_BULLET, {"rotation": -PI/2}, false)
			bullet_manager.spawn_bullet(shoot_position() + Vector2(30, -10), PLAYER_BULLET, {"rotation": -PI/2}, false)
	bullet_cooldown = true

func shoot_position() -> Vector2:
	return self.position + Vector2(0, -10)

func player_hit():
	if bomb_safety_wait:
		return
	bomb_safety_wait = true
	await Util.timer(0.133)
	bomb_safety_wait = false
	if bomb_safety:
		return
	SE.sound_effect("Death")
	self.self_modulate.a = 0
	player_sprite.self_modulate.a = 0
	hitbox_sprite.self_modulate.a = 0
	
	EventBus.emit_signal("lose_life")
	Game.points *= 0.7
	Game.bombs = 0
	bomb_tracker = 0
	level_tracker = 0
	
	level = 1
	
	velocity = Vector2.ZERO
	controllable = false
	alive = false
	hurtbox.set_deferred("monitoring", false)
	hurt_anim.play("default")
	hurt_anim.visible = true
	await hurt_anim.animation_finished
	hurt_anim.visible = false
	
	position = Vector2(GAME_REGION.x / 2, GAME_REGION.y * 1.25)
	
	self.self_modulate.a = 1
	player_sprite.self_modulate.a = 1
	hitbox_sprite.self_modulate.a = 1
	var revive_tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	revive_tween.tween_property(self, "position", Vector2(GAME_REGION.x * 0.5, GAME_REGION.y * 0.8), 1.5)
	await revive_tween.finished
	
	controllable = true
	alive = true
	hurtbox.set_deferred("monitoring", true)

func gain_points(points: int):
	Game.points += points
	bomb_tracker += points
	level_tracker += points
	life_tracker += points
	if level_tracker >= 250 && level == 2:
		level_tracker = 0
		level += 1
	elif level_tracker >= 100 && level == 1:
		level_tracker = 0
		level += 1
	if bomb_tracker >= 150 && Game.bombs < 3:
		bomb_tracker = 0
		Game.gain_bomb()
	if life_tracker >= 150 && Game.life < 3:
		life_tracker = 0
		Game.life += 1

func _on_hurtbox_area_entered(area: Area2D) -> void:
	player_hit()
	area.get_parent().bullet_hit()


func _on_point_attractor_area_entered(area: Area2D) -> void:
	area.get_parent().player = self

func _on_point_pickup_area_entered(area: Area2D) -> void:
	area.get_parent().die()
