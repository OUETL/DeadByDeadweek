extends Node

onready var music = $"../Music"
onready var text = $"../UICanvasLayer/RichTextLabel"

var firstEntryIntoEdge = true
	
func _ready():
	
	for area in get_children():
		# Ignore if not an Area object.
		if !(area is Area):
			continue
			
		print('Hooking up entry/exit signals for area "%s"' % area.name)
		area.connect('body_entered', self, '_on_entry', [area])
		area.connect('body_exited', self, '_on_exit', [area])

#
# Called when something ('body') entered one of the specified zones ('zone).
#
func _on_entry(body, area):
	print('in: ' + body.name + ' ' + area.name)

	# Player entered the Edge room? Only trigger first time!
	if (body.name == 'JaneDough') and (area.name == 'EdgeDoorway'):
		if firstEntryIntoEdge == true:
			firstEntryIntoEdge = false
			music._play_track('CreepyTheme')
	
	# Player entered test zone? Change text.
	if (body.name == 'JaneDough') and (area.name == 'Test'):
		text.text = 'Inside!'
	
func _on_exit(body, area):
	print('out: ' + body.name + ' ' + area.name)

	# Player exited test zone? Change text.
	if (body.name == 'JaneDough') and (area.name == 'Test'):
		text.text = ''
