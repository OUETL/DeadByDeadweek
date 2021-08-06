extends Spatial

onready var chillMusic = $ChillTheme
onready var creepyMusic = $CreepyTheme
onready var trackchangeCollide = $DoorwayMusicChange

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	

func _trackChange():
	if chillMusic.stream_paused:
		chillMusic.stop()
		creepyMusic.play()
	elif not chillMusic.stream_paused:
		creepyMusic.stop()
		chillMusic.play()
