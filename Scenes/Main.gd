extends Spatial

# Expose these to the editor GUI for convenience
export var music_path = "Music"
export var zones_path = "ActiveZones"
export var text_path = "UICanvasLayer/RichTextLabel"

# Maps track name => AudioStreamPlayer object for that track.
var track_name_to_audio_player = {}

# Maps area name -> true (is inside area) or false (if outside)
var player_in_area = {}

# Maps key code to key latch; used to mimic keyup/keydown events
var key_latch_map = {}

# Remember whether we've entered the Edge area before!
var firstEntryIntoEdge = true

# Status update text
var text

# Standard Godot methods follow

func _ready():
	# Try to find the text node
	text = get_node(text_path)
	if text == null:
		print('Unable to find text node at "%s"' + text_path)
	
	# Look at child nodes of music node, set up track_name_to_player map for
	# any children of type AudioStreamPlayer
	var music = get_node(music_path)
	if music == null:
		print('Unable to find music container node at "%s"' + music_path)
	else:
		for track in music.get_children():
			if !(track is AudioStreamPlayer): continue
			print('Adding track "%s"' % track.name)
			track_name_to_audio_player[track.name] = track

	# Look at child nodes of active zones node, connect signals for any
	# children of type Area
	var zones = get_node(zones_path)
	if zones == null:
		print('Unable to find active zone container node at "%s"' + zones_path)
	else:
		for area in zones.get_children():
			if !(area is Area): continue
			player_in_area[area.name] = false
			print('Hooking up entry/exit signals for area "%s"' % area.name)
			area.connect('body_entered', self, '_on_entry', [area])
			area.connect('body_exited', self, '_on_exit', [area])

# Change the music track; also stops any track(s) that may already be playing
func _play_track(track_name):
	# Stop any existing music
	for track_name in track_name_to_audio_player:
		track_name_to_audio_player[track_name].stop()
	
	# Try to start new music track
	if track_name in track_name_to_audio_player:
		print('Changing music to "%s"' % track_name)
		track_name_to_audio_player[track_name].play()
	else:
		print('Unknown music "%s"' % track_name)

func _input(event):
	if event is InputEventKey:
		# Mimic keydown / keyup events
		var state = event.pressed
		var code = event.scancode		
		var result = key_latch_map.get(code)
		
		if (result == null) or (result != state):
			if state == true:
				_key_down(event)
			else:
				_key_up(event)
			key_latch_map[code] = state

# Additional methods follow

# Update the status text
func _update_text(new_text):
	if text == null: return
	text.text = new_text

# Called when something ('body') enters one of the specified areas ('area').
func _on_entry(body, area):
	print('in: ' + body.name + ' ' + area.name)

	# Player-based actions
	if body.name == 'JaneDough':
		player_in_area[area.name] = true

		# Player entered the Edge room? Only trigger first time!
		if area.name == 'EdgeDoorway':
			if firstEntryIntoEdge == true:
				firstEntryIntoEdge = false
				_play_track('CreepyTheme')

		# Player entered test zone? Change text.
		if area.name == 'Test':
			_update_text('Press "a" to activate!')

# Called when something ('body') exits one of the specified areas ('area').
func _on_exit(body, area):
	print('out: ' + body.name + ' ' + area.name)

	# Player-based actions
	if body.name == 'JaneDough':
		player_in_area[area.name] = false

		# Player exited test zone? Clear text.
		if area.name == 'Test':
			_update_text('')

# Mimic keydown / keyup events (apparently not provided by Godot?)
func _key_down(event):
	# Check if specific key pressed in a region. Change to user-specified
	# action rather than hardcoded scancode!
	if (event.scancode == KEY_Q) and (player_in_area['Test'] == true):
		print('Triggered!')

func _key_up(event):
	pass
