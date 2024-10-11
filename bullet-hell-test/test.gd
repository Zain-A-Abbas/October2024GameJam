extends Node2D


@onready var multi_mesh_instance_2d: MultiMeshInstance2D = $MultiMeshInstance2D
var bullets: Array[Bullet] = []

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	Bullet.initializeBullets(multi_mesh_instance_2d)
	for i in Bullet.BULLET_COUNT:
		var bullet: Bullet = Bullet.getBullet()
		var bulletVelocity: Vector2 = Vector2(randi_range(-100, 100), 0).rotated(deg_to_rad(randf_range(0, 360)))
		bullet.activate(Vector2(600, 360), bulletVelocity)
	

func _physics_process(delta: float) -> void:
	Bullet.processBullets(delta)
