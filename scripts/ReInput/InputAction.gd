class_name InputAction

var statehistory : Array[Dictionary]

var value : float

var deadzone : float
var tap_threshold : float
var high_threshold : float
var hold_threshold : float
var doubletap_threshold : float

var buffer_length : int

func update(input : float, delta : float) -> void:
	var _is_zero : bool = input < deadzone and input > -deadzone
	var _is_high : bool = not _is_zero and \
		(input >= high_threshold or input <= -high_threshold)

	if not _is_zero:
		value = input
	else:
		value = 0.0

	if statehistory.size() > 0 and statehistory[0]["is_high"] == _is_high and \
		statehistory[0]["is_zero"] == _is_zero:
		statehistory[0]["duration"] = statehistory[0]["duration"] + delta
		if not _is_zero and statehistory[0]["duration"] >= hold_threshold:
			statehistory[0]["is_held"] = true
	else:
		if statehistory.size() >= buffer_length:
			statehistory.pop_back()
		pushstate(_is_high, _is_zero)
		if statehistory.size() > 1 and not statehistory[1]["is_zero"] and \
				_is_zero and statehistory[1]["duration"] < tap_threshold:
					statehistory[0]["is_tapped"] = true

		if statehistory.size() > 3 and not _is_zero and \
			statehistory[1]["is_zero"] and not statehistory[2]["is_zero"] and \
			statehistory[1]["duration"] < doubletap_threshold:
				statehistory[0]["is_doubletapped"] = true

func get_value() -> float:
	return value

func get_duration() -> float:
	return statehistory[0]["duration"]

func is_zero() -> bool:
	return statehistory[0]["is_zero"]

func is_high() -> bool:
	return statehistory[0]["is_high"]

func is_held() -> bool:
	return statehistory[0]["is_held"]

func was_held() -> bool:
	for state : Dictionary in statehistory:
		if state["is_held"] == true:
			return true

	return false

func was_tapped() -> bool:
	for state : Dictionary in statehistory:
		if state["is_tapped"] == true:
			return true

	return false

func was_doubletapped() -> bool:
	for state : Dictionary in statehistory:
		if state["is_doubletapped"] == true:
			return true

	return false

func was_pressed() -> bool:
	for state : Dictionary in statehistory:
		if not (state["is_zero"] and state["is_held"] and state["is_tapped"]):
			return true

	return false

func untap() -> void:
	statehistory[0]["is_tapped"] = false

func undoubletap() -> void:
	statehistory[0]["is_doubletapped"] = false

func clear_history() -> void:
	if statehistory.size() > 1:
		if statehistory.resize(1) != OK:
			print("failed to clear history")

func pushstate(_is_high : bool, _is_zero : bool) -> void:
	statehistory.push_front({})
	statehistory[0]["is_high"] = _is_high
	statehistory[0]["is_zero"] = _is_zero
	statehistory[0]["duration"] = 0.0
	statehistory[0]["is_held"] = false
	statehistory[0]["is_tapped"] = false
	statehistory[0]["is_doubletapped"] = false
