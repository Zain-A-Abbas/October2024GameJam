extends Node2D
class_name Game

@onready var ui: CanvasLayer = $UI

static var points: int = 0
static var bombs: int = 0
static var player: Player

static var run_seconds: int = 0
static var run_ms: int = 0

func _physics_process(delta: float) -> void:
	run_ms = Time.get_ticks_msec()
	run_seconds = run_ms / 1000
	ui.time_text(run_ms)
