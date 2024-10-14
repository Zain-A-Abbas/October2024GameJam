extends Node
class_name BulletManager

const BULLET_COUNT: int = 1000
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
	var new_script: Script = bulletData.custom_script.duplicate() if bulletData.custom_script else load("res://Enemy/Bullet.gd")
	
	var old_body = bullet.static_body_2d
	var old_notifier = bullet.visible_on_screen_notifier_2d
	var old_collision = bullet.collision_shape_2d
	bullet.set_script(new_script)
	bullet.static_body_2d = old_body
	bullet.visible_on_screen_notifier_2d = old_notifier
	bullet.collision_shape_2d = old_collision
	
	bullet.setup_bullet(bulletData, args)
	bullet.activate(bulletPosition)

func clear_bullets():
	for child in get_children():
		if is_instance_of(child, Bullet):
			if child.active:
				child.deactivate()
