extends Node2D
class_name Game

@onready var ui: CanvasLayer = $UI
@onready var fade_1: ColorRect = $Fade1
@onready var fade_2: ColorRect = $Fade2
@onready var game_area: Node2D = $SubViewport/GameArea

static var points: int = 0
static var bombs: int = 0
static var life: int = 3
static var player: Player

static var run_seconds: int = 0
static var run_ms: int = 0
var counting_time: bool = false

func _ready() -> void:
	ui.time_text(0)
	fade_1.visible = true
	fade_2.visible = true
	fade_1.modulate.a = 1.0
	fade_2.modulate.a = 1.0
	bombs = 1
	await Util.timer(0.5)
	var fade_tween: Tween = create_tween()
	fade_tween.tween_property(fade_1, "modulate:a", 0.0, 1.0)
	fade_tween.tween_property(fade_2, "modulate:a", 0.0, 1.0)
	await fade_tween.finished
	await Util.timer(0.5)
	counting_time = true
	game_area.initialize()

func _physics_process(delta: float) -> void:
	if counting_time:
		run_ms = Time.get_ticks_msec()
		run_seconds = run_ms / 1000
		ui.time_text(run_ms)

static func gain_bomb():
	bombs += 1
