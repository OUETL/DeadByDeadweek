extends Control
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		startGame()

func startGame():
	get_tree().change_scene("res://Scenes/Story1.tscn")
