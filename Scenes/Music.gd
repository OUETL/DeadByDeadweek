extends Node

# Maps track name => AudioStreamPlayer object for that track.
var m = {}

func _ready():
	# Find any AudioStreamPlayer objects in node's children.
	for x in get_children():
		if x is AudioStreamPlayer:
			m[x.name] = x

func _play_track(track_name):
	# Stop any existing music
	for name in m:
		m[name].stop()
	
	# Try to start new music track
	if track_name in m:
		print('Changing music track to "%s"' % track_name)
		m[track_name].play()
	else:
		print('Unknown music track "%s"' % track_name)
		
	
