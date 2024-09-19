class_name EditorPalette

# textures
var w : String
var x : String
var y : String
var z : String

# weights
var r : float
var g : float
var b : float
var a : float

var slope_value : float
var smooth_value : float

func _init(_w : String, _x : String, _y : String, _z : String, \
		_r : float, _g : float, _b : float, _a : float, \
		_smooth_value : float, _slope_value : float) -> void:
	w = _w
	x = _x
	y = _y
	z = _z

	r = _r
	g = _g
	b = _b
	a = _a

	smooth_value = _smooth_value
	slope_value = _slope_value
