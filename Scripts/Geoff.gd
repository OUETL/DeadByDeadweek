# player controller script for the character Rasmus Rasmus

extends Area2D

export var speed = 400 # speed of character
onready var lifeTimer = $lifeTimer
onready var lifestatusSprite = $LifeBar.texture_progress
onready var lifestatusFrames = preload("res://Assets/Resources/lifeprogressanimation.tres")

var currentLife = 23

func _ready():
	lifestatusSprite.set_current_frame(currentLife) 
	lifeTimer.start()
	
func _process(delta):	
	var velocity = Vector2() # player movement vector
	
	# determining direction that the player should move, storing it in var velocity
	if Input.is_action_pressed("p2_right"):
		velocity.x += 1
	if Input.is_action_pressed("p2_left"):
		velocity.x -= 1
	if Input.is_action_pressed("p2_down"):
		velocity.y += 1
	if Input.is_action_pressed("p2_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # normalizes velocity vector to a magnitude of 1 before multipl;ying by speed so that moving diagonally isn't faster than moving up/down or left/right, due to vector addition
		$AnimatedSprite.play() # plays the animation when character is moving
	else:
		$AnimatedSprite.stop() # stops the animation from playing when character is stopped
	
	# moving the character on the screen
	position += velocity * delta # changing character position
	
	# no walking up animation, so we only need to flip the walking animation depending on the x velocity component
	if velocity.x != 0: # checking if we are moving in the x direction
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x < 0 # boolean input, so we flip if velocity.x is less than 0 (ie moving left) only, and don't flip when moving to the right
	if velocity.x == 0 && velocity.y == 0:
		$AnimatedSprite.animation = "idle"
	#update health variable
	currentLife = lifeTimer.get_time_left()
	#set frame as currentLife int
	lifestatusSprite.set_current_frame(currentLife)
	
