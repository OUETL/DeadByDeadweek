extends KinematicBody

var path = []
var path_node_index = 0
var player = null

# Allow to be changed in the editor for convienence
export var speed = 90
export var player_path = "../../JaneDough"

onready var nav = get_parent()

func _ready():
	player = get_node(player_path)
	if player == null:
		print("Problem getting player object from path '%s'" % player_path)

func _physics_process(delta):
	if path_node_index < path.size():
		var direction = (path[path_node_index] - global_transform.origin)
		if direction.length() < 1:
			path_node_index += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)

func set_destination(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node_index = 0

func _on_Timer_timeout():
	set_destination(player.global_transform.origin)
