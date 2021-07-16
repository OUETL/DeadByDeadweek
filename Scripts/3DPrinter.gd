extends Node2D

onready var gantrySprite = $gantry/gantrySprite
onready var gantry = $gantry
onready var zdropTimer = $zdropTimer
onready var toolhead = $gantry/toolhead

var vel = Vector2()
var facingDir = Vector2()
var moveSpeed = 250
var curPos = Vector2()

var dropSpeed = 250

func _ready():
	curPos.x = 0

func _process(delta):
	#animation controller
	if Input.is_action_pressed("ui_left"):
		gantrySprite.play()
	if Input.is_action_pressed("ui_right"):
		gantrySprite.play()
	if Input.is_action_just_released("ui_left"): 
		gantrySprite.stop()
	if Input.is_action_just_released("ui_right"): 
		gantrySprite.stop()
	vel = Vector2()
	
	#inputs
	if Input.is_action_pressed("ui_left") && curPos.x > -193:
		vel.x -= 1
		curPos.x -= 1
		facingDir = Vector2(-1,0)
	if Input.is_action_pressed("ui_right") && curPos.x < 194:
		vel.x += 1
		curPos.x += 1
		facingDir = Vector2(1,0)
	
	#normalize the velocity to prevent faster diagonal movement
	vel = vel.normalized()
	
	#move the player
	toolhead.move_and_slide(vel * moveSpeed, Vector2.ZERO)
