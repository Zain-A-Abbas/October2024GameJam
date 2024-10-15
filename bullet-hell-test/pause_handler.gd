extends Node

@onready var game_area: Node2D = $".."
@onready var pause: ColorRect = $"../Pause"


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if game_area.process_mode == PROCESS_MODE_DISABLED:
			game_area.process_mode = Node.PROCESS_MODE_INHERIT
			pause.visible = false
			BGM.change_volume(1.0)
		else:
			game_area.process_mode = PROCESS_MODE_DISABLED
			pause.visible = true
			BGM.change_volume(0.5)
