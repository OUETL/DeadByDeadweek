extends KinematicBody

export var speed = 100
export var acceleration = 20

var movement_allowed: bool = true

func _ready():
	pass

func _process(delta):
	
	# Only process movement input if movement is enabled.
	if movement_allowed:
		var direction = Vector3()
		
		# Separate the up/down and left/right keypress handling as we can use
		# e.g. up and left simultaneously when moving
		
		if Input.is_action_pressed("ui_up"):
			direction -= transform.basis.z
		elif Input.is_action_pressed("ui_down"):
			direction += transform.basis.z
		if Input.is_action_pressed("ui_left"):
			direction -= transform.basis.x
		elif Input.is_action_pressed("ui_right"):
			direction += transform.basis.x
		
		direction = direction.normalized()
		
		var velocity = direction * speed
		velocity.linear_interpolate(velocity, acceleration*delta)
		
		move_and_slide(velocity, Vector3.UP)

#
# Provide additional functionality
#

func allow_movement(enable: bool):
	movement_allowed = enable

func trigger_death():
	allow_movement(false)
	# ... do whatever ...
