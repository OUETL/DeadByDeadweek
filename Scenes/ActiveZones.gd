extends Node

onready var music = $"../Music"

# Map zone name -> zone metadata (currently just whether it's the first time the
# zone was entered
var zones = {
	'EdgeDoorway': true,
}
	
func _ready():
	#
	# For each of the named zones in 'zones', find the area object and
	# hook the 'body_entered' / 'body_exited' signals up to our '_on_entry'
	# and '_on_exit' methods.
	#
	for name in zones:
		# Can't find area?
		var area = get_node(name)
		if area == null:
			print('Unable to find zone object called "%s"' % name)
			continue
		
		# Hook up signals
		area.connect('body_entered', self, '_on_entry', [area])
		area.connect('body_exited', self, '_on_exit', [area])

#
# Called when something ('body') entered one of the specified zones ('zone).
#
func _on_entry(body, area):
	print('in: ' + body.name + ' ' + area.name)

	# Player entered the Edge room? Only trigger first time!
	if (body.name == 'JaneDough') and (area.name == 'EdgeDoorway'):
		if zones[area.name] == true:
			zones[area.name] = false
			music._track_change()
	
func _on_exit(body, area):
	print('out: ' + body.name + ' ' + area.name)
