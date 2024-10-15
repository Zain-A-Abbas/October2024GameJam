extends Node2D
class_name Game

@onready var ui: CanvasLayer = $UI
@onready var fade_1: ColorRect = $Fade1
@onready var fade_2: ColorRect = $Fade2
@onready var game_area: Node2D = $SubViewport/GameArea
@onready var game_over: Control = $GameOver
@onready var win: Control = $Win

const INTRO_TITLE = preload("res://IntroTitle.tscn")

static var points: int = 0
static var bombs: int = 0
static var life: int = 3
static var player: Player

static var run_seconds: float = 0
static var run_ms: int = 0
var counting_time: bool = false

func _ready() -> void:
	EventBus.lose_life.connect(lose_life)
	EventBus.win.connect(game_win)
	points = 0
	bombs = 0
	life = 3
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
	if !ui:
		return
	if counting_time:
		run_seconds += delta
		run_ms = run_seconds * 1000
		ui.time_text(run_ms)

func lose_life():
	life -= 1
	if life == 0:
		game_area.queue_free()
		ui.queue_free()
		BGM.stop_bgm()
		SE.stop_se()
		SE.sound_effect("Bomb")
		game_over.visible = true
		await Util.timer(3.0)
		get_tree().change_scene_to_packed(load("res://IntroTitle.tscn"))

static func gain_bomb():
	bombs += 1

func game_win():
	win.modulate.a = 0.0
	win.visible = true
	var win_tween: Tween = create_tween()
	win_tween.tween_property(
		win,
		"modulate:a",
		1.0,
		2.0
	)
	await win_tween.finished
	await Util.timer(10.0)
	
	get_tree().change_scene_to_packed(load("res://IntroTitle.tscn"))
