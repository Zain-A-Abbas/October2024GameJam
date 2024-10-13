extends Node
class_name TraumaComponent

@onready var parent = get_parent()

var three_dimensional: bool = false

# Position of parent
var base_position: Vector2 = Vector2.ZERO
# Position of parent if parent is a 3d node (like a sprite)
var base_position_3d: Vector3 = Vector3.ZERO
# Intensity of trauma. Every whole number of trauma means number of pixels moved
var trauma_intensity: float = 0.0
# trauma_reduction is deducted from trauma_intensity every second
var trauma_reduction: float = 0.0

func _ready():
	await owner.ready
	if parent is Node3D:
		three_dimensional = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma_intensity > 0.0:
		_trauma_process(delta)

func _trauma_process(delta: float):
	trauma_intensity = clamp(trauma_intensity - trauma_reduction * delta, 0.0, trauma_intensity)
	if trauma_intensity == 0.0:
		trauma_reduction = 0.0
	if !three_dimensional:
		parent.position.x = base_position.x + trauma_intensity * (randf() * 2.0 - 1.0)
		parent.position.y = base_position.y + trauma_intensity * (randf() * 2.0 - 1.0)
	else:
		parent.position.x = base_position_3d.x + trauma_intensity * (randf() * 2.0 - 1.0)
		parent.position.y = base_position_3d.y + trauma_intensity * (randf() * 2.0 - 1.0)

func begin_trauma(intensity: float, reduction: float):
	if trauma_intensity == 0.0:
		if !three_dimensional:
			base_position = parent.position
		else:
			base_position_3d = parent.position
	trauma_intensity += intensity
	trauma_reduction += reduction

func stop_trauma():
	trauma_intensity = 0.0
