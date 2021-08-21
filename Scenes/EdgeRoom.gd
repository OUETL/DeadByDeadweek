extends Spatial

signal trackchangeCollide_onEnter

var firstEntry = true

onready var chillMusic = $ChillTheme
onready var creepyMusic = $CreepyTheme
	
func _track_change():
	chillMusic.stop()
	creepyMusic.play()

func _on_player_entry(body):	
	if (firstEntry == true) and (body.name == "JaneDough"):
		firstEntry = false
		_track_change()
		print("Changing track")

	print("Collision: ", body, body.name)
