extends Spatial

export var music_path = "Music"
export var zones_path = "ActiveZones"
export var text_path = "UICanvasLayer/RichTextLabel"

# Maps track name => AudioStreamPlayer object for that track.
var track_name_to_audio_player = {}

# Remember whether we've entered the Edge area before!
var firstEntryIntoEdge = true

# Status update text
var text

# Called when the node enters the scene tree for the first time.
func _ready():
	#
	# Try to find the text node
	#
	text = get_node(text_path)
	if text == null:
		print('Unable to find text node at "%s"' + text_path)
	
	#
	# Look at child nodes of music node, set up track_name_to_player map
	#
	var music = get_node(music_path)
	if music == null:
		print('Unable to find music container node at "%s"' + music_path)
	else:
		for track in music.get_children():
			if !(track is AudioStreamPlayer): continue
			print('Adding track "%s"' % track.name)
			track_name_to_audio_player[track.name] = track
	
	#
	# Look at child nodes of active zones node, set up signals
	#
	var zones = get_node(zones_path)
	if zones == null:
		print('Unable to find active zone container node at "%s"' + zones_path)
	else:
		for area in zones.get_children():
			if !(area is Area): continue
			print('Hooking up entry/exit signals for area "%s"' % area.name)
			area.connect('body_entered', self, '_on_entry', [area])
			area.connect('body_exited', self, '_on_exit', [area])

#
# Change the music track; also stops any track(s) that may already be playing
#
func _play_track(track_name):
	# Stop any existing music
	for track_name in track_name_to_audio_player:
		track_name_to_audio_player[track_name].stop()
	
	# Try to start new music track
	if track_name in track_name_to_audio_player:
		print('Changing music track to "%s"' % track_name)
		track_name_to_audio_player[track_name].play()
	else:
		print('Unknown music track "%s"' % track_name)

#
# Update the status text
#
func _update_text(new_text):
	if text == null: return
	text.text = new_text
	
#
# Called when something ('body') enters one of the specified areas ('area').
#
func _on_entry(body, area):
	print('in: ' + body.name + ' ' + area.name)
	
	# Player entered the Edge room? Only trigger first time!
	if (body.name == 'JaneDough') and (area.name == 'EdgeDoorway'):
		if firstEntryIntoEdge == true:
			firstEntryIntoEdge = false
			_play_track('CreepyTheme')

	# Player entered test zone? Change text.
	if (body.name == 'JaneDough') and (area.name == 'Test'):
		_update_text('Inside!')
	
#
# Called when something ('body') exits one of the specified areas ('area').
#
func _on_exit(body, area):
	print('out: ' + body.name + ' ' + area.name)

	# Player exited test zone? Change text.
	if (body.name == 'JaneDough') and (area.name == 'Test'):
		_update_text('')
