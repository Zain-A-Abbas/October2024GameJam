extends CanvasLayer

@onready var time_label: Label = $PanelContainer/VBoxContainer/PanelContainer5/HBoxContainer/TimeLabel
@onready var score_label: Label = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/ScoreLabel
@onready var level_label: Label = $PanelContainer/VBoxContainer/PanelContainer4/HBoxContainer/LevelLabel

func _physics_process(delta: float) -> void:
	time_text()
	score_label.text = str(Game.points)
	level_label.text = str(Game.player.level)

func time_text():
	var ms: int = Time.get_ticks_msec()
	var minutes: int = ms / 60000
	var seconds: int = (ms / 1000) % 60
	var milliseconds: int = ms % 1000
	time_label.text = "%03d:%02d:%03d" % [minutes, seconds, milliseconds]
