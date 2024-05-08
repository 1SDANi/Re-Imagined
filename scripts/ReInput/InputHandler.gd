class_name InputHandler

var gmp : Dictionary
var kbm : Dictionary
var mom : Dictionary
var actions : Dictionary

var default_deadzone: float
var default_tap_threshold : float
var default_high_threshold : float
var default_hold_threshold : float
var default_doubletap_threshold : float

var mouse_motion : Vector2

var default_buffer_length : int

var cam_speed_x : float
var cam_speed_y : float

enum MOUSE_DIRECTION
{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func set_cam_speed_x(speed : float) -> void:
	cam_speed_x = speed

func set_cam_speed_y(speed : float) -> void:
	cam_speed_y = speed

func get_cam_speed_x() -> float:
	return cam_speed_x

func get_cam_speed_y() -> float:
	return cam_speed_y

func is_mouse_captured() -> bool:
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED

func is_mouse_free() -> bool:
	return Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func toggle_mouse_capture() -> void:
	if is_mouse_captured():
		release_mouse()
	else:
		capture_mouse()

func update_all(delta : float) -> void:
	update_inputs(delta)
	update_keys(delta)
	update_mouse_movement(delta)

func update_inputs(delta : float) -> void:
	for input in gmp:
		actions[gmp[input]].update(Input.get_action_strength(input), delta)

func update_keys(delta : float) -> void:
	for action in kbm:
		actions[kbm[action]].update(Input.is_key_pressed(action), delta)

func update_mouse_movement(delta : float) -> void:
	var up : float = mouse_motion.y if mouse_motion.y > 0.0 else 0.0
	var down : float = -mouse_motion.y if mouse_motion.y < 0.0 else 0.0
	var right : float = mouse_motion.x if mouse_motion.x > 0.0 else 0.0
	var left : float = -mouse_motion.x if mouse_motion.x < 0.0 else 0.0

	actions[mom[MOUSE_DIRECTION.UP]].update(up, delta)
	actions[mom[MOUSE_DIRECTION.DOWN]].update(down, delta)
	actions[mom[MOUSE_DIRECTION.LEFT]].update(left, delta)
	actions[mom[MOUSE_DIRECTION.RIGHT]].update(right, delta)
	mouse_motion = Vector2.ZERO

func mouse_motion_event(event) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event.relative.x != 0:
			mouse_motion.x = event.relative.x
		if event.relative.y != 0:
			mouse_motion.y = event.relative.y

func is_action_zero(action : String) -> bool:
	if not has_action(action):
		return false

	return actions[action].is_zero()

func is_action_high(action : String) -> bool:
	if not has_action(action):
		return false

	return actions[action].is_high()

func is_action_held(action : String) -> bool:
	if not has_action(action):
		return false

	return actions[action].is_held()

func was_action_held(action : String) -> bool:
	if not has_action(action):
		return false

	return actions[action].was_held()

func was_action_tapped(action : String) -> bool:
	if not has_action(action):
		return false

	return actions[action].was_tapped()

func was_action_doubletapped(action : String) -> bool:
	if not has_action(action):
		return false

	return actions[action].was_doubletapped()

func was_action_pressed(action : String) -> bool:
	if not has_action(action):
		return false

	return actions[action].was_pressed()

func untap_action(action : String) -> void:
	actions[action].untap()

func undoubletap_action(action : String) -> void:
	actions[action].untap()

func get_action_value(action : String) -> float:
	if not has_action(action) or is_action_zero(action):
		return 0.0

	return actions[action].value

func get_action_duration(action : String) -> float:
	if not has_action(action) or is_action_zero(action) or \
			not actions[action].statehistory.size() > 0:
		return 0.0

	return actions[action].statehistory[0]["duration"]

func get_axis_value_spacey(action_pos : String, action_neg : String, \
		bias_pos : bool) -> float:
	if not (has_action(action_pos) and has_action(action_neg)):
		return 0.0

	var pos_value = get_action_value(action_pos)
	var pos_duration = get_action_duration(action_pos)
	var pos_zero = is_action_zero(action_pos)
	var neg_value = get_action_value(action_neg)
	var neg_duration = get_action_duration(action_neg)
	var neg_zero = is_action_zero(action_neg)

	if not pos_zero and (pos_duration < neg_duration or neg_zero):
		return pos_value
	elif not neg_zero and \
			(neg_duration < pos_duration or pos_zero or not bias_pos):
		return -neg_value
	else:
		return pos_value

func get_axis_value_biased(action_pos : String, action_neg : String, \
		bias_pos : bool) -> float:
	if not (has_action(action_pos) and has_action(action_neg)):
		return 0.0

	var pos_value = get_action_value(action_pos)
	var pos_zero = is_action_zero(action_pos)
	var neg_value = get_action_value(action_neg)
	var neg_zero = is_action_zero(action_neg)

	if bias_pos:
		if not pos_zero:
			return pos_value
		else:
			return -neg_value
	else:
		if not neg_zero:
			return -neg_value
		else:
			return pos_value

func get_axis_value_total(action_pos : String, action_neg : String, absolute : bool) -> float:
	if not (has_action(action_pos) and has_action(action_neg)):
		return 0.0

	var pos_value = get_action_value(action_pos)
	var neg_value = get_action_value(action_neg)

	return pos_value - (neg_value * (1 if absolute else -1))

func clear_action_history(action : String) -> void:
	actions[action].clear_history()

func clear_action_histories(_actions : Array[String]) -> void:
	for action in _actions:
		clear_action_history(action)

func has_input(input : String) -> bool:
	return gmp.has(input)

func has_key(key : Key) -> bool:
	return kbm.has(key)

func has_mouse_movement(direction : MOUSE_DIRECTION) -> bool:
	return mom.has(direction)

func has_action(action : String) -> bool:
	return actions.has(action)

func is_input(input : String, action : String) -> bool:
	return has_input(input) and gmp.get(input) == action

func is_key(key : Key, action : String) -> bool:
	return has_key(key) and kbm.get(key) == action

func is_mouse_movement(direction : MOUSE_DIRECTION, action : String) -> bool:
	return has_mouse_movement(direction) and mom.get(direction) == action

func set_input(input : String, action : String) -> bool:
	gmp[input] = action
	return true

func set_key(key : Key, action : String) -> bool:
	kbm[key] = action
	return true

func set_mouse_movement(direction : MOUSE_DIRECTION, action : String) -> bool:
	mom[direction] = action
	return true

func add_input(input : String, action : String) -> bool:
	if has_input(input):
		return false

	set_input(input, action)

	if not has_action(action):
		add_action(action)

	return true

func add_key(key : Key, action : String) -> bool:
	if has_key(key):
		return false

	set_key(key, action)

	if not has_action(action):
		add_action(action)

	return true

func add_mouse_movement(direction : MOUSE_DIRECTION, action : String) -> bool:
	if has_mouse_movement(direction):
		return false

	set_mouse_movement(direction, action)

	if not has_action(action):
		add_action(action)

	return true

func ensure_input(input : String, action : String) -> bool:
	if has_input(input):
		return is_input(input, action)

	return set_input(input, action)

func ensure_key(key : Key, action : String) -> bool:
	if has_key(key):
		return is_key(key, action)

	return set_key(key, action)

func ensure_mouse_movement(direction : MOUSE_DIRECTION, action : String) -> bool:
	if has_mouse_movement(direction):
		return is_mouse_movement(direction, action)

	return set_mouse_movement(direction, action)

func change_input(input : String, action : String) -> bool:
	return has_input(input) and set_input(input, action)

func change_key(key : Key, action : String) -> bool:
	return has_key(key) and set_key(key, action)

func change_mouse_movement(direction : MOUSE_DIRECTION, action : String) -> bool:
	return has_mouse_movement(direction) and set_mouse_movement(direction, action)

func add_action(action : String) -> bool:
	if has_action(action):
		return false

	actions[action] = InputAction.new()
	set_deadzone(action, default_deadzone)
	set_tap_threshold(action, default_tap_threshold)
	set_doubletap_threshold(action, default_doubletap_threshold)
	set_hold_threshold(action, default_hold_threshold)
	set_high_threshold(action, default_high_threshold)
	set_buffer_length(action, default_buffer_length)
	return true

func set_deadzone(action: String, deadzone : float) -> bool:
	if not has_action(action):
		return false

	actions[action].deadzone = deadzone
	return true

func set_default_deadzone(deadzone : float) -> void:
	default_deadzone = deadzone

func set_tap_threshold(action: String, tap_threshold : float) -> bool:
	if not has_action(action):
		return false

	actions[action].tap_threshold = tap_threshold
	return true

func set_default_tap_threshold(tap_threshold : float) -> void:
	default_tap_threshold = tap_threshold

func set_high_threshold(action: String, high_threshold : float) -> bool:
	if not has_action(action):
		return false

	actions[action].high_threshold = high_threshold
	return true

func set_default_high_threshold(high_threshold : float) -> void:
	default_high_threshold = high_threshold

func set_hold_threshold(action: String, hold_threshold : float) -> bool:
	if not has_action(action):
		return false

	actions[action].hold_threshold = hold_threshold
	return true

func set_default_hold_threshold(hold_threshold : float) -> void:
	default_hold_threshold = hold_threshold

func set_doubletap_threshold(action: String, doubletap_threshold : float) -> bool:
	if not has_action(action):
		return false

	actions[action].doubletap_threshold = doubletap_threshold
	return true

func set_default_doubletap_threshold(doubletap_threshold : float) -> void:
	default_doubletap_threshold = doubletap_threshold

func set_buffer_length(action: String, buffer_length : int) -> bool:
	if not has_action(action):
		return false

	actions[action].buffer_length = buffer_length
	return true

func set_default_buffer_length(buffer_length : int) -> void:
	default_buffer_length = buffer_length
