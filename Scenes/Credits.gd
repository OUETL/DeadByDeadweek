extends Control

onready var camHandle = $Camera2D

var camOffset = 0.1
var speed = .5

func _process(delta):
	camOffset += speed
	camHandle.set_offset(Vector2(0, camOffset))
