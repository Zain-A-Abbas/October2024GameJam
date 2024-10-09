extends Node2D


@onready var multi_mesh_instance_2d: MultiMeshInstance2D = $MultiMeshInstance2D
var bullets: Array[Bullet] = []

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	Bullet.initializeBullets(multi_mesh_instance_2d)
	var bulletTestCount: int = 8
	for i in bulletTestCount:
		var bullet: Bullet = Bullet.getBullet()
		bullet.activate(Vector2(600, 360), Vector2(randi_range(-200, 200), randi_range(-150, 150)))
	

func _physics_process(delta: float) -> void:
	Bullet.processBullets(delta)
