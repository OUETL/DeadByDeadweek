extends Spatial

onready var brettPath = $Path/PathFollow
onready var brett = $Path/PathFollow/Brett

var brettPathCurrent = 0.0
#expressed as 0-1; 1 being a full loop on the path
export var brettMoveSpeed = 0.01

func _ready():
	brettPath.set_unit_offset(.6) 

func _process(delta):
	brettPathCurrent = (brettPath.get_unit_offset())
	print(brettPathCurrent)
	brettPath.set_unit_offset(brettPathCurrent + brettMoveSpeed)
	
	
