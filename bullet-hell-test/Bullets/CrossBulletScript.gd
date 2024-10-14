extends Bullet

var bullet_state: String = "Wait"
var starting_position: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if !active:
		return
	if bullet_state == "Wait":
		rotation = position.angle_to_point(Game.player.position) - PI/2
		bullet_rotation = position.angle_to_point(Game.player.position) - PI/2
	else:
		position += Vector2(0, speed).rotated(bullet_rotation) * delta

func activate(startPos: Vector2):
	starting_position = startPos
	static_body_2d.set_deferred("monitorable", false)
	active = true
	modulate.a = 0.0
	visible = true
	position = Game.player.position + starting_position
	var activate_tween: Tween = create_tween()
	activate_tween.tween_property(self, "modulate:a", 1.0, 0.25)
	await Util.timer(1.0)
	static_body_2d.set_deferred("monitorable", true)
	bullet_state = "Go"

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if bullet_state == "Wait":
		return
	
	await Util.timer(1.0)
	if !visible_on_screen_notifier_2d.is_on_screen():
		deactivate()
