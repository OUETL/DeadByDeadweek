extends KinematicBody

var speed = 100
var acceleration = 20

var mouse_sensitivity = 0.1

var direction = Vector3()
var velocity = Vector3()

onready var pivot = $Pivot
onready var gun_pivot = $LookPivot

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _process(delta):
	direction = Vector3()
	
	if Input.is_action_pressed("p2_up"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("p2_down"):
		direction += transform.basis.z
	elif Input.is_action_pressed("p2_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("p2_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	velocity = direction * speed
	velocity.linear_interpolate(velocity, acceleration*delta)
	move_and_slide(velocity, Vector3.UP)

