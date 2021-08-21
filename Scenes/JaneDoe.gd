extends KinematicBody

export var speed = 100
export var acceleration = 20

var direction = Vector3()
var velocity = Vector3()

func _ready():
	# Hides mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	direction = Vector3()
	
	# Separate the up/down and left/right keypress handling as we can use
	# e.g. up and left simultaneously when moving
	
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

