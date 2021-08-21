extends KinematicBody

var speed = 100
var acceleration = 20

onready var edgeRoom = $'../Navigation/NavigationMeshInstance/EdgeRoom'
onready var edgeRoomDoorwayArea = $'../Navigation/NavigationMeshInstance/EdgeRoom/DoorwayArea'

var direction = Vector3()
var velocity = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	edgeRoomDoorwayArea.connect('body_entered', edgeRoom, '_on_player_entry')

func _process(delta):
	direction = Vector3()
	
	if Input.is_action_pressed("p2_up"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("p2_down"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("p2_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("p2_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	velocity = direction * speed
	velocity.linear_interpolate(velocity, acceleration*delta)
	move_and_slide(velocity, Vector3.UP)

