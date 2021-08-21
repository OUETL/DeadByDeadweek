extends Spatial

var firstEntry = true

onready var chillMusic = $ChillTheme
onready var creepyMusic = $CreepyTheme
onready var doorwayArea = $DoorwayArea
	
func _ready():
	# Tell doorwayArea to connect any body_entered signals it might
	# generate to our _on_player_entry() method
	doorwayArea.connect('body_entered', self, '_on_player_entry')

func _track_change():
	chillMusic.stop()
	creepyMusic.play()

func _on_player_entry(body):
	if (firstEntry == true) and (body.name == "JaneDough"):
		firstEntry = false
		_track_change()
		print("Changing track")
