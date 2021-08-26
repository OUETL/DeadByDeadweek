extends Control

onready var theBiz = $BG/TextureRect
onready var topText = $BG/topText
onready var bottomText = $BG/bottomText
onready var sfxRect = $BG/ColorRect

var textCount = 0

func _ready():
	pass # Replace with function body
	
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		startGame()

func startGame():
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_textChangeTimer_timeout():
	if textCount == 2:
		startGame()
	elif textCount == 0:
		bottomText.set_text("It's a tech space that provides VR and free 3D printing.")
		textCount += 1
	elif textCount > 0:
		bottomText.set_text("You better get moving. Can't be late on your first shift!")
		textCount += 1

