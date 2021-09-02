#
# Main script handles music and responding to player entering specific zones.
# Also handles responding to key presses in "special" areas.
#
extends Spatial

# Expose these to the editor GUI for convenience
export var music_path = "Music"
export var zones_path = "ActiveZones"
export var text_path = "UICanvasLayer/RichTextLabel"
# Maps track name => AudioStreamPlayer object for that track.
var track_name_to_audio_player = {}

# Maps area name -> true (inside area) or false (outside area)
var player_in_area = {}

# Used to swap music only the first time player enters the Edge
var firstEntryIntoEdge = true
onready var brettSprite = $Brett/AnimatedSprite

# Status update text
var text
#Sound effects
onready var eatSound = $candySFX
#lifebar/timer
onready var lifeTimer = $p1lifeTimer
onready var lifestatusSprite = $Control/p1LifeBar.texture_progress
onready var lifestatusFrames = preload("res://Assets/Resources/lifeprogressanimation.tres")
var currentTime = 24
export var currentLife = 23
#
# Standard Godot methods follow
#

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
			area.connect('body_entered', self, 'on_area_entry', [area])
			area.connect('body_exited', self, 'on_area_exit', [area])
			
	#Set frame for life bar
	lifestatusSprite.set_current_frame(currentLife) 

func _physics_process(delta):
	_updateHealth()

func _input(event):
	if event is InputEventKey:
		# Mimic keyup/keydown; echo == a repeated event when key held down
		if event.is_echo() == false:
			if event.pressed == true:
				key_down(event)
			else:
				key_up(event)
#
# Additional methods follow
#

#update health
func _updateHealth():
	#update currentTime
	currentTime = lifeTimer.get_time_left()
	#update health variable
	currentLife = currentTime
	#set frame as currentLife int
	lifestatusSprite.set_current_frame(currentLife)
	
# Change the music track; also stops any track(s) that may already be playing
func play_track(track_name):
	# Stop any existing music
	for track_name in track_name_to_audio_player:
		track_name_to_audio_player[track_name].stop()

	# Try to start new music track
	if track_name in track_name_to_audio_player:
		print('Changing music to "%s"' % track_name)
		track_name_to_audio_player[track_name].play()
	else:
		print('Unknown music "%s"' % track_name)

# Update the status text
func update_text(new_text):
	if text == null: return
	text.text = new_text

# Called when something ('body') enters one of the specified areas ('area').
func on_area_entry(body, area):
	print('in: ' + body.name + ' ' + area.name)

	# Player-based actions
	if body.name == 'JaneDough':
		player_in_area[area.name] = true

		# Player entered the Edge room? Only trigger first time!
		if area.name == 'EdgeDoorway':
			if firstEntryIntoEdge == true:
				firstEntryIntoEdge = false
				play_track('CreepyTheme')
				brettSprite.play("Transform")
				#Start HP timer
				lifeTimer.start()

		# Player entered test zone? Change text.
		if area.name == 'Test':
			update_text('Press "a" to activate!')
			
		# Player entered test zone? Change text.
		if area.name == 'Candy':
			update_text('Candy Devoured! +10 HP!')
			#play sound starting at .78
			eatSound.play(0.78)
			#update lifeTimer with the current time reading
			currentTime += 10
			lifeTimer.start(currentTime)
			_updateHealth()
			$ActiveZones/Candy.queue_free()
			

# Called when something ('body') exits one of the specified areas ('area').
func on_area_exit(body, area):
	print('out: ' + body.name + ' ' + area.name)

	# Player-based actions
	if body.name == 'JaneDough':
		player_in_area[area.name] = false

		# Player exited test zone? Clear text.
		if area.name == 'Test':
			update_text('')

# Mimic keydown / keyup events (apparently not provided by Godot?)
func key_down(event):
	# Check if specific key pressed in a region. Change to user-specified
	# action rather than hardcoded scancode!
	#if (event.scancode == KEY_Q) and (player_in_area['Test'] == true):
	#	print('Triggered!')
	
	# Check if specific action key pressed in a region.
	if (Input.is_action_pressed("ui_accept")) and (player_in_area['Test'] == true):
		print('Triggered!')

func key_up(event):
	pass
	
