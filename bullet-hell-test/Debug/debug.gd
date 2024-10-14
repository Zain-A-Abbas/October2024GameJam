extends Node

func _ready() -> void:
	var angle: float = deg_to_rad(36)
	
	var a: Vector2 = Vector2(128, 0)
	for i in 5:
		a = a.rotated((PI / 2) - angle / 2)
		print(rad_to_deg((PI / 2) - angle / 2))
		print(a)
		print("---")
