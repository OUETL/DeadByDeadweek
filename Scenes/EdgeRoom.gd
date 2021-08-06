extends Spatial

signal trackchangeCollide_onEnter

onready var chillMusic = $ChillTheme
onready var creepyMusic = $CreepyTheme
onready var trackchangeBody = $DoorwayMusicChange
onready var trackchangeCollide = $DoorwayMusicChange/CollisionShape

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	pass
	
func _on_character_body_enter(body):
	print("Collision")
	if (body.get_name() == "Player"):
		print("Ouch!")
	
func _trackChange():
	if chillMusic.stream_paused:
		chillMusic.stop()
		creepyMusic.play()
	elif not chillMusic.stream_paused:
		creepyMusic.stop()
		chillMusic.play()

func _on_EdgeRoom_trackchangeCollide_onEnter():
	_trackChange()
