extends Node2D

const GAME = preload("res://Game.tscn")
@onready var intro_nodes: Control = $CanvasLayer/Control/IntroNodes
@onready var intro_text: Label = $CanvasLayer/Control/IntroNodes/IntroText
@onready var title_bg: TextureRect = $CanvasLayer/Control/TitleNodes/TitleBG
@onready var logo: TextureRect = $CanvasLayer/Control/TitleNodes/Logo
@onready var title_options: VBoxContainer = $CanvasLayer/Control/TitleNodes/TitleOptions
@onready var start_label: Label = $CanvasLayer/Control/TitleNodes/TitleOptions/StartLabel
@onready var exit_label: Label = $CanvasLayer/Control/TitleNodes/TitleOptions/ExitLabel
@onready var control: Control = $CanvasLayer/Control

const INTRO: Array[String] = [
	"In the Ancient of Days...",
	"Humanity had attempted to leave their station,\nand ascend to the realm beyond Earth...",
	"For their hubris, He struck them down, and scattered them...",
	"And now, eons since, humanity has sided with the\nforces of Lucifer, to once again...",
	"*drum roll*",
	"... CONSTRUCT a tower, to heaven itself.",
	"You, Archangel Gabriel-Chan, must put a stop to them.",
	"Not only is the tower an affront to God, but also...",
	"... The tower, fails to meet safety compliance standards."
]

var state = "Intro"
var intro_tween: Tween
var selected_option: int = 0
var highlight_tween: Tween
var skip_on_gameover: bool = false

func _ready() -> void:
	intro_nodes.visible = false
	title_bg.visible = false
	logo.visible = false
	title_options.visible = false
	highlight(-1)
	intro()

func intro():
	await Util.timer(0.2)
	BGM.load_bgm("Title")
	BGM.play_bgm()
	await Util.timer(0.1)
	if skip_on_gameover || Input.is_action_pressed("bomb"):
		pass
	else:
		await Util.timer(0.5)
		intro_text.text = ""
		if state != "None":
			intro_nodes.visible = true
			for text in INTRO:
				if state == "None":
					break
				intro_text.modulate.a = 0.0
				intro_text.text = text
				intro_tween = create_tween()
				intro_tween.tween_property(intro_text, "modulate:a", 1.0, 0.4)
				await intro_tween.finished
				if state == "None":
					break
				intro_tween = create_tween()
				intro_tween.tween_property(intro_text, "modulate:a", 1.0, 4.0)
				await intro_tween.finished
				if state == "None":
					break
				intro_tween = create_tween()
				intro_tween.tween_property(intro_text, "modulate:a", 0.0, 0.4)
				await intro_tween.finished

	state = "None"
	
	title_bg.modulate.a = 0.0
	title_bg.visible = true
	var title_tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	title_tween.tween_property(title_bg, "modulate:a", 1.0, 2.0)
	await title_tween.finished
	
	await Util.timer(0.1)
	
	logo.modulate.a = 0.0
	logo.visible = true
	logo.pivot_offset = logo.size / 2
	title_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true)
	title_tween.tween_property(logo, "modulate:a", 1.0, 0.7)
	title_tween.tween_property(logo, "scale", Vector2.ONE, 0.7).from(Vector2(1.3, 1.3))
	await Util.timer(0.1)
	SE.sound_effect("Title")
	await title_tween.finished
	
	await Util.timer(0.1)
	
	title_options.modulate.a = 0.0
	title_options.visible = true
	title_options.pivot_offset = title_options.size / 2
	title_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true)
	title_tween.tween_property(title_options, "modulate:a", 1.0, 0.7)
	title_tween.tween_property(title_options, "position", title_options.position, 0.7).from(title_options.position + Vector2(60, 0))
	await title_tween.finished
	highlight(0)
	state = "Control"

func skip_intro():
	intro_nodes.visible = false
	state = "None"
	if intro_tween:
		intro_tween.custom_step(1000)
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") && state == "Intro":
		skip_intro()
	
	if state == "Control":
		if Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down"):
			selected_option = 0 if selected_option == 1 else 1
			highlight(selected_option)
		
		if Input.is_action_just_pressed("shoot"):
			SE.ui_confirm()
			if selected_option == 0:
				BGM.fadeout_bgm()
				state == "None"
				var fade_tween: Tween = create_tween()
				fade_tween.tween_property(control, "modulate:v", 0.0, 1.0)
				await fade_tween.finished
				get_tree().change_scene_to_packed(load("res://Game.tscn"))
				return
			if selected_option == 1:
				get_tree().quit()

func highlight(index: int):
	SE.ui_scroll()
	var nodes: Array[Control] = [start_label, exit_label]
	for i in nodes.size():
		if i != index:
			nodes[i].modulate.v = 0.25
		else:
			nodes[i].modulate.v = 1.0
			if highlight_tween:
				highlight_tween.custom_step(1000)
			highlight_tween = create_tween().set_parallel(true)
			highlight_tween.tween_property(nodes[i], "position", nodes[i].position, 0.2).from(nodes[i].position + Vector2(16, 0))
			highlight_tween.tween_property(nodes[i], "modulate:a", 1.0, 0.2).from(0.2)
			
