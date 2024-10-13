extends Sprite2D
class_name Bullet

@onready var static_body_2d: Area2D = $StaticBody2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

var player: bool = false
var active: bool = false
var speed: float = 10
var bullet_rotation: float = 0.0
var sprite_rotation: float = 0.0

func initialize(player_bullet: bool = false):
	player = player_bullet
	if player:
		static_body_2d.set_collision_layer_value(3, false)
		static_body_2d.set_collision_layer_value(2, true)
	deactivate()

func activate(startPos: Vector2):
	position = startPos
	static_body_2d.set_deferred("monitorable", true)
	active = true
	visible = true

func bullet_hit():
	deactivate()

func deactivate():
	visible = false
	active = false
	static_body_2d.set_deferred("monitorable", false)

func setup_bullet(bullet_resource: BulletData, args: Dictionary = {}):
	texture = bullet_resource.sprite
	modulate.h = bullet_resource.hue
	collision_shape_2d.shape = bullet_resource.bullet_collision
	speed = bullet_resource.speed * 800
	if args.has("rotation"):
		bullet_rotation = args["rotation"] - PI/2
		rotation = bullet_rotation
	sprite_rotation = bullet_resource.sprite_rotation

func _physics_process(delta: float) -> void:
	if active:
		position += Vector2(0, speed).rotated(bullet_rotation) * delta
		if sprite_rotation:
			rotation += sprite_rotation * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if !visible_on_screen_notifier_2d.is_on_screen():
		deactivate()
