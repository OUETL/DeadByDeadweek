extends KinematicBody

# Allow to be changed in the editor for convienence
export var speed = 90
export var player_path = "../../JaneDough"
export var navigation_path = "../../Navigation"
onready var mainScene = get_node("/root/Scene/Main")

onready var sprite = $AnimatedSprite

var path = []
var path_node_index = 0

var nav = null
var player = null

# Distance of Brett -> specified player in a straight line; note that this may
# not reflect the path that Brett actually takes to intercept the player, as
# Brett is constrained to move on the NavMesh which is likely composed of a
# rectangular grid of locations. Calculated in _physics_process().
var distance_to_player = 1_000_000 # huge initial value!

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
	# Move towards player, guided by whatever navmesh system we're using
	if path_node_index < path.size():
		var direction = (path[path_node_index] - global_transform.origin)
		if direction.length() < 1:
			path_node_index += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
	#Attack player if close enough
	if distance_to_player < 10:
		_attack()
	
	# Calculate straight-line distance to player (not neccessarily the direction
	# we're moving in, see note where distance_to_player variable is defined).
	if player != null:
		var brett_position = global_transform.origin
		var player_position = player.global_transform.origin
		distance_to_player = brett_position.distance_to(player_position)
		

func set_destination(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node_index = 0

func _on_Timer_timeout():
	set_destination(player.global_transform.origin)
	
func _attack():
	sprite.play("TazeAttack")

func _on_AnimatedSprite_animation_finished():
	if not sprite.get_animation() == "idleBrett" && "WalkEvilBrett":
		$transformTimer.start()
		sprite.play("WalkEvilBrett")

func _on_transformTimer_timeout():
	sprite.play("Transform")
