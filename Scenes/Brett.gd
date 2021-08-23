extends KinematicBody

# Allow to be changed in the editor for convienence
export var speed = 90
export var player_path = "../../JaneDough"
export var navigation_path = "../../Navigation"

var path = []
var path_node_index = 0

var nav = null
var player = null

func _ready():
	# Try to find specified player node
	player = get_node(player_path)
	if player == null:
		print('Problem getting player node from path "%s"' % player_path)
		if !(player is KinematicBody):
			print('Warning; player node (%s") is not type KinematicBody!' % player_path)

	# Try to find specified navigation node
	nav = get_node(navigation_path)
	if nav == null:
		print("Problem getting navigation node from path '%s'" % navigation_path)
		if !(nav is Navigation):
			print('Warning; navigation node (%s") is not type Navigation!' % navigation_path)

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
