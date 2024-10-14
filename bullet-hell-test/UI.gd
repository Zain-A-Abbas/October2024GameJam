extends CanvasLayer

@onready var time_label: Label = $PanelContainer/VBoxContainer/PanelContainer5/HBoxContainer/TimeLabel
@onready var score_label: Label = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/ScoreLabel
@onready var level_label: Label = $PanelContainer/VBoxContainer/PanelContainer4/HBoxContainer/LevelLabel

#region bombs and life
@onready var life_1: TextureRect = $PanelContainer/VBoxContainer/PanelContainer6/HBoxContainer/HBoxContainer/Life1
@onready var life_2: TextureRect = $PanelContainer/VBoxContainer/PanelContainer6/HBoxContainer/HBoxContainer/Life2
@onready var life_3: TextureRect = $PanelContainer/VBoxContainer/PanelContainer6/HBoxContainer/HBoxContainer/Life3

@onready var bomb_1: TextureRect = $PanelContainer/VBoxContainer/PanelContainer3/HBoxContainer/HBoxContainer/Bomb1
@onready var bomb_2: TextureRect = $PanelContainer/VBoxContainer/PanelContainer3/HBoxContainer/HBoxContainer/Bomb2
@onready var bomb_3: TextureRect = $PanelContainer/VBoxContainer/PanelContainer3/HBoxContainer/HBoxContainer/Bomb3
#endregion


func _physics_process(delta: float) -> void:
	score_label.text = str(Game.points)
	level_label.text = str(Game.player.level)
	bomb_update(Game.bombs)
	life_update(Game.life)

func time_text(ms: int):
	var minutes: int = ms / 60000
	var seconds: int = (ms / 1000) % 60
	var milliseconds: int = ms % 1000
	time_label.text = "%03d:%02d:%03d" % [minutes, seconds, milliseconds]

func life_update(life_count: int):
	life_1.modulate.a = float(life_count >= 1)
	life_2.modulate.a = float(life_count >= 2)
	life_3.modulate.a = float(life_count >= 3)

func bomb_update(bomb_count: int):
	bomb_1.modulate.a = float(bomb_count >= 1)
	bomb_2.modulate.a = float(bomb_count >= 2)
	bomb_3.modulate.a = float(bomb_count >= 3)
