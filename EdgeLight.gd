extends OmniLight

const TWOPI = 2.0*PI

export var period_s = 2.0

export var min_range = 10.0
export var max_range = 20.0

var t = 0

func _process(delta):
	t += delta
	if t >= period_s: t = t - period_s
	
	var u = t / period_s
	omni_range = min_range + (1.0+cos(u * TWOPI))/2 * (max_range-min_range)
