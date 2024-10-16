class_name InputState

# High Value
var is_high : bool

# Low Value
var is_low : bool

# No Value
var is_zero : bool

# Extended non-Zero Value
var is_held : bool

# Extended Zero Value
var is_idle : bool

# High to Zero
var is_dropped : bool

# non-Zero Value Released
var is_pressed : bool

# Brief non-Zero Value Released
var is_tapped : bool

# Back-to-Back Taps
var is_doubletapped : bool

# The input Value, from Zero to One
var value : float

# How long the Value has not been Zero
var duration : float

func update(delta : float) -> void:
	duration += delta

func _init(_value : float) -> void:
	is_high = false
	is_low = false
	is_zero = false
	is_held = false
	is_dropped = false
	is_pressed = false
	is_tapped = false
	is_doubletapped = false

	value = _value
	duration = 1.0

func clone(state : InputState) -> void:
	is_high = state.is_high
	is_low = state.is_low
	is_zero = state.is_zero
	is_held = state.is_held
	is_dropped = state.is_dropped
	is_pressed = state.is_pressed
	is_tapped = state.is_tapped
	is_doubletapped = state.is_doubletapped

	value = state.value
	duration = state.duration
