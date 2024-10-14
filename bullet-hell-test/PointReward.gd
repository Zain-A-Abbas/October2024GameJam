extends Node2D
class_name  PointReward

@onready var point_label: Label = $PanelContainer/PointLabel
@onready var panel_container: PanelContainer = $PanelContainer

const FALLING_SPEED: float = 150
const PICKUP_SPEED: float = 250

var pickup_speed: float = 250
var player: Player
var moving_down: bool = false
var points: int = 0
var dying: bool = false

func _ready() -> void:
	point_label.text = str(points)
	match points:
		1:
			panel_container.get_theme_stylebox("panel").bg_color = Color(0.2, 0.75, 0.2)
		2:
			panel_container.get_theme_stylebox("panel").bg_color = Color(0.2, 0.2, 0.75)
		3:
			panel_container.get_theme_stylebox("panel").bg_color = Color(0.75, 0.2, 0.2)
	
	spawn()
	await get_tree().create_timer(0.5).timeout
	moving_down = true
	

func _physics_process(delta: float) -> void:
	if player:
		var angle_to_player: float = position.angle_to_point(player.position)
		var pickup_direction: Vector2 = Vector2(1, 0).rotated(angle_to_player) * pickup_speed * delta
		pickup_speed += delta * 500
		position += pickup_direction
	elif moving_down:
		position.y += FALLING_SPEED * delta

func spawn():
	var spawn_tween: Tween = create_tween().set_ease(Tween.EASE_IN)
	spawn_tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.2
	).from(Vector2(1.5, 1.5))
	await spawn_tween.finished

func die():
	dying = true
	var die_tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	die_tween.tween_property(
		self,
		"scale",
		Vector2.ZERO,
		0.2
	).from(Vector2.ONE)
	await die_tween.finished
	if player:
		SE.sound_effect("UIScroll")
		player.gain_points(points)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()
