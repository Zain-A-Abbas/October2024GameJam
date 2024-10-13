extends Node

func timer(time: float):
	await get_tree().create_timer(time).timeout
