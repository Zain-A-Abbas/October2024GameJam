extends Node

# If one is played right before a battle begins then place it in Battle

# Battle


# Non-battle


# Functionality

const MIN_DB := -80.0
const MAX_DB := -8.0

class BackgroundMusic extends Node:
	var bgm_player: AudioStreamPlayer
	var is_playing: bool
	
	var current_volume: float = 1.0
	
	func _init():
		bgm_player = AudioStreamPlayer.new()
		bgm_player.volume_db = MIN_DB
	
	# This volume is applied -before- taking settings into account
	func set_volume(new_db: float):
		bgm_player.volume_db = new_db
		
	
	func play(audio_stream: AudioStream, bgm_db: float):
		add_child(bgm_player)
		bgm_player.stream = audio_stream
		bgm_player.volume_db = bgm_db
		bgm_player.play()
		is_playing = true
		bgm_player.finished.connect(loop_music)
	
	func stop():
		is_playing = false
		bgm_player.stop()
	
	func pause():
		is_playing = false
		bgm_player.stream_paused = true
		
	func unpause():
		is_playing = true
		bgm_player.stream_paused = false
	
	func loop_music():
		bgm_player.play()
	

var loaded_bgm := []
var current_bgm = null
var bgm_player: BackgroundMusic


func load_bgm(track: String):
	var queue_bgm = load("res://Audio/Music/" + str(track) + ".wav")
	loaded_bgm.push_front(queue_bgm)
	current_bgm = loaded_bgm[0]

func play_bgm(volume: float = 1.0):
	bgm_player = BackgroundMusic.new()
	add_child(bgm_player)
	assert(current_bgm != null && bgm_player != null)
	bgm_player.play(current_bgm, get_audio_db(volume))
 
func pause_bgm():
	bgm_player.pause()

func unpause_bgm():
	bgm_player.unpause()
 
func stop_bgm():
	bgm_player.stop()
	bgm_player = null

func fadeout_bgm(fadeout_time: float = 0.5):
	if bgm_player == null:
		return
	var fade_tween: Tween = get_tree().create_tween().bind_node(self)
	var prev_volume: float = bgm_player.current_volume
	fade_tween.tween_method(
		change_volume,
		prev_volume,
		0.0,
		fadeout_time
	)
	await fade_tween.finished
	bgm_player = null

func unload_bgm():
	loaded_bgm = []
	bgm_player = null
	current_bgm = null

# Called when the bgm sound is changed by the player in settings 
func bgm_setting_changed():
	if bgm_player != null:
		change_volume(bgm_player.current_volume)

# Changing the volume of the bgm player
func change_volume(new_volume: float):
	if bgm_player != null:
		bgm_player.current_volume = new_volume
		bgm_player.set_volume(get_audio_db(new_volume))

# Calculates the decibel scale of the audio
func get_audio_db(volume: float = 1.0):
	var audio_scale: float = volume
	var _db: float = -48.0 + 6.0 * (log(100.0 * audio_scale) / log(2))
	return _db
