extends Node

onready var chillMusic = $ChillTheme
onready var creepyMusic = $CreepyTheme

func _track_change():
	print('Changing track')
	chillMusic.stop()
	creepyMusic.play()
