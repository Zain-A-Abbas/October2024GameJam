extends Node
class_name BulletManager

const BULLET_COUNT: int = 500
const BULLET = preload("res://Enemy/Bullet.tscn")

@export var player_bullets: bool = false

func _ready() -> void:
	for bullet in BULLET_COUNT:
		var new_bullet: Bullet = BULLET.instantiate()
		add_child(new_bullet)
		new_bullet.initialize(player_bullets)

func get_bullet() -> Bullet:
	for child in get_children():
		if is_instance_of(child, Bullet):
			if !child.active:
				return child
	return null

func spawn_bullet(bulletPosition: Vector2, bulletData: BulletData, args: Dictionary = {}):
	var bullet: Bullet = get_bullet()
	bullet.setup_bullet(bulletData, args)
	bullet.activate(bulletPosition)
