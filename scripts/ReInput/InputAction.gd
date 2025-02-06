class_name InputAction

var statehistory : Array[InputState]

var axis : InputAxis

var deadzone : float
var tap_threshold : float
var high_threshold : float
var hold_threshold : float
var doubletap_threshold : float

var buffer_length : int

var positive : bool

func _init() -> void:
	var state : InputState = InputState.new(0.0)
	state.is_zero = true
	statehistory.push_front(state)
	axis = null

func update(input : float, delta : float) -> void:
	var _is_zero : bool = input < deadzone and input > -deadzone
	var _is_high : bool = not _is_zero and input >= high_threshold
	var same_highness : bool = statehistory[0].is_high == _is_high
	var same_nillness : bool = statehistory[0].is_zero == _is_zero
	var value : float = 0.0

	if not _is_zero:
		value = input
	else:
		value = 0.0

	if statehistory.size() > 0 and same_highness and same_nillness:
		statehistory[0].duration += delta
		updatestate(value)
		if statehistory[0].duration >= hold_threshold:
			if _is_zero:
				statehistory[0].is_idle = true
			else:
				statehistory[0].is_held = true
	else:
		if statehistory.size() >= buffer_length:
			statehistory.pop_back()
		pushstate(value, _is_high, _is_zero, delta)

	if is_axis(): axis.update_action(delta, positive, self)

func bind_axis(_axis : InputAxis, _positive : bool) -> bool:
	if axis != null:
		return false

	axis = _axis
	positive = _positive
	return true

func is_axis() -> bool:
	return axis != null

func clear_history() -> void:
	if statehistory.size() > 1:
		if statehistory.resize(1) != OK:
			print("failed to clear history")

func get_state() -> InputState:
	return statehistory[0]

func get_average() -> float:
	var average : float = 0.0

	for state : InputState in statehistory:
		average += state.value

	average /= statehistory.size()

	return average

func updatestate(value : float) -> void:
	statehistory[0].value = value

func pushstate(value : float, high : bool, zero : bool, delta : float) -> void:
	var last_duration : float

	var was_zero : bool
	if statehistory.size() > 0:
		last_duration = statehistory[0].duration
		was_zero = statehistory[0].is_zero

	statehistory.push_front(InputState.new(value))
	statehistory[0].is_high = high
	statehistory[0].is_low = not (high or zero)
	statehistory[0].is_zero = zero
	if statehistory.size() > 1:
		if not was_zero and not zero:
			statehistory[0].duration = last_duration + delta

		if not was_zero and zero and statehistory[0].is_high:
			statehistory[0].is_dropped = true

		if not was_zero and zero and last_duration >= tap_threshold:
			statehistory[0].is_pressed = true

		if not was_zero and zero and last_duration < tap_threshold:
			if statehistory.size() > 2 and statehistory[2].is_tapped and \
				last_duration < doubletap_threshold:
				statehistory[0].is_doubletapped = true
			else:
				statehistory[0].is_tapped = true
