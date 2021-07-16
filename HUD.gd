extends Control

onready var lifestatusSprite = $LifeBar.texture_progress
onready var lifestatusFrames = preload("res://Assets/Resources/lifeprogressanimation.tres")

var currentLife = 23

func _ready():
	lifestatusSprite.set_current_frame(currentLife) 
	
func _process(delta):
	lifestatusSprite.set_current_frame(currentLife)
