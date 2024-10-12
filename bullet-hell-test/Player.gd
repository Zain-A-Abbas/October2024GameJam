extends CharacterBody2D
class_name Player
@onready var hurtbox: Area2D = $Hurtbox

const PLAYER_SPEED: float = 20000.0
const BULLET_COOLDOWN: float = 0.1
const PLAYER_BULLET = preload("res://Bullets/PlayerBullet.tres")

@export var bullet_manager: BulletManager
var controllable: bool = true
var cooldown_tracker: float = 0.0
var bullet_cooldown: bool = false

var level: int = 1

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
	var input_lr: float = Input.get_axis("ui_left", "ui_right")
	var input_ud: float = Input.get_axis("ui_up", "ui_down")
	velocity = Vector2(input_lr, input_ud).normalized() * PLAYER_SPEED * delta
	
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	if bullet_cooldown:
		return
	bullet_manager.spawn_bullet(self.position, PLAYER_BULLET, {"rotation": -PI/2})
	bullet_cooldown = true

func player_hit():
	visible = false
	hurtbox.set_deferred("monitoring", false)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	player_hit()
	area.get_parent().bullet_hit()
