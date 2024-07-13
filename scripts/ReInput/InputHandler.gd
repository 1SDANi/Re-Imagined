class_name InputHandler

var gmp : Dictionary
var kbm : Dictionary
var mod : Dictionary
var mob : Dictionary
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

enum MOUSE_DIR
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
	update_mouse_dir(delta)
	update_mouse_buttons(delta)

func update_inputs(delta : float) -> void:
	for input : String in gmp:
		var i : InputAction = actions[gmp[input]]
		i.update(Input.get_action_strength(input), delta)

func update_keys(delta : float) -> void:
	for action : Key in kbm:
		var a : InputAction = actions[kbm[action]]
		a.update(Input.is_key_pressed(action), delta)

func update_mouse_buttons(delta : float) -> void:
	for action : MouseButton in mob:
		if action == MouseButton.MOUSE_BUTTON_WHEEL_UP: continue
		if action == MouseButton.MOUSE_BUTTON_WHEEL_DOWN: continue
		var a : InputAction = actions[mob[action]]
		a.update(Input.is_mouse_button_pressed(action), delta)

func update_mouse_dir(delta : float) -> void:
	var up : float = mouse_motion.y if mouse_motion.y > 0.0 else 0.0
	var down : float = -mouse_motion.y if mouse_motion.y < 0.0 else 0.0
	var right : float = mouse_motion.x if mouse_motion.x > 0.0 else 0.0
	var left : float = -mouse_motion.x if mouse_motion.x < 0.0 else 0.0

	var up_action : InputAction = actions[mod[MOUSE_DIR.UP]]
	var down_action : InputAction = actions[mod[MOUSE_DIR.DOWN]]
	var left_action : InputAction = actions[mod[MOUSE_DIR.LEFT]]
	var right_action : InputAction = actions[mod[MOUSE_DIR.RIGHT]]

	up_action.update(up, delta)
	down_action.update(down, delta)
	left_action.update(left, delta)
	right_action.update(right, delta)
	mouse_motion = Vector2.ZERO

func mouse_wheel_event(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		var e : InputEventMouseButton = event
		var action : InputAction = actions[mob[e.button_index]]
		if e.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
			action.update(1.0, 1.0)
		elif e.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
			action.update(1.0, 1.0)

func mouse_motion_event(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var e : InputEventMouseMotion = event
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if e.relative.x != 0:
				mouse_motion.x = e.relative.x
			if e.relative.y != 0:
				mouse_motion.y = e.relative.y

func is_action_zero(action : String) -> bool:
	if not has_action(action):
		return false

	var a : InputAction = actions[action]

	return a.is_zero()

func is_action_high(action : String) -> bool:
	if not has_action(action):
		return false

	var a : InputAction = actions[action]

	return a.is_high()

func is_action_held(action : String) -> bool:
	if not has_action(action):
		return false

	var a : InputAction = actions[action]

	return a.is_held()

func was_action_held(action : String) -> bool:
	if not has_action(action):
		return false

	var a : InputAction = actions[action]

	return a.was_held()

func was_action_tapped(action : String) -> bool:
	if not has_action(action):
		return false

	var a : InputAction = actions[action]

	return a.was_tapped()

func was_action_doubletapped(action : String) -> bool:
	if not has_action(action):
		return false

	var a : InputAction = actions[action]

	return a.was_doubletapped()

func was_action_pressed(action : String) -> bool:
	if not has_action(action):
		return false

	var a : InputAction = actions[action]

	return a.was_pressed()

func untap_action(action : String) -> void:
	var a : InputAction = actions[action]
	a.untap()

func undoubletap_action(action : String) -> void:
	var a : InputAction = actions[action]
	a.untap()

func get_action_value(action : String) -> float:
	if not has_action(action) or is_action_zero(action):
		return 0.0

	var a : InputAction = actions[action]

	return a.value

func get_action_duration(action : String) -> float:
	var a : InputAction = actions[action]

	if not has_action(action) or is_action_zero(action) or \
			not a.statehistory.size() > 0:
		return 0.0

	return a.statehistory[0]["duration"]

func get_axis_value_spacey(action_pos : String, action_neg : String, \
		bias_pos : bool) -> float:
	if not (has_action(action_pos) and has_action(action_neg)):
		return 0.0

	var pos_value : float = get_action_value(action_pos)
	var pos_duration : float = get_action_duration(action_pos)
	var pos_zero : float = is_action_zero(action_pos)
	var neg_value : float = get_action_value(action_neg)
	var neg_duration : float = get_action_duration(action_neg)
	var neg_zero : float = is_action_zero(action_neg)

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

	var pos_value : float = get_action_value(action_pos)
	var pos_zero : float = is_action_zero(action_pos)
	var neg_value : float = get_action_value(action_neg)
	var neg_zero : float = is_action_zero(action_neg)

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

	var pos_value : float = get_action_value(action_pos)
	var neg_value : float = get_action_value(action_neg)

	return pos_value - (neg_value * (1 if absolute else -1))

func clear_action_history(action : String) -> void:
	var a : InputAction = actions[action]
	a.clear_history()

func clear_action_histories(_actions : Array[String]) -> void:
	for action : String in _actions:
		clear_action_history(action)

func has_input(input : String) -> bool:
	return gmp.has(input)

func has_key(key : Key) -> bool:
	return kbm.has(key)

func has_mouse_dir(dir : MOUSE_DIR) -> bool:
	return mod.has(dir)

func has_mouse_button(mouse_button : MouseButton) -> bool:
	return kbm.has(mouse_button)

func has_action(action : String) -> bool:
	return actions.has(action)

func is_input(input : String, action : String) -> bool:
	return has_input(input) and gmp.get(input) == action

func is_key(key : Key, action : String) -> bool:
	return has_key(key) and kbm.get(key) == action

func is_mouse_dir(dir : MOUSE_DIR, action : String) -> bool:
	return has_mouse_dir(dir) and mod.get(dir) == action

func is_mouse_button(mouse_button : MouseButton, action : String) -> bool:
	return has_mouse_button(mouse_button) and mob.get(mouse_button) == action

func set_input(input : String, action : String) -> bool:
	gmp[input] = action
	return true

func set_key(key : Key, action : String) -> bool:
	kbm[key] = action
	return true

func set_mouse_dir(dir : MOUSE_DIR, action : String) -> bool:
	mod[dir] = action
	return true

func set_mouse_button(mouse_button : MouseButton, action : String) -> bool:
	mob[mouse_button] = action
	return true

func add_input(input : String, action : String) -> bool:
	if has_input(input):
		return false

	if not set_input(input, action):
		return false

	if has_action(action):
		return false

	if not add_action(action):
		return false

	return true

func add_key(key : Key, action : String) -> bool:
	if has_key(key):
		return false

	if not set_key(key, action):
		return false

	if has_action(action):
		return false

	if not add_action(action):
		return false

	return true

func add_mouse_dir(dir : MOUSE_DIR, action : String) -> bool:
	if has_mouse_dir(dir):
		return false

	if not set_mouse_dir(dir, action):
		return false

	if has_action(action):
		return false

	if not add_action(action):
		return false

	return true

func add_mouse_button(mouse_button : MouseButton, action : String) -> bool:
	if has_mouse_button(mouse_button):
		return false

	if not set_mouse_button(mouse_button, action):
		return false

	if has_action(action):
		return false

	if not add_action(action):
		return false

	return true

func ensure_input(input : String, action : String) -> bool:
	if has_input(input):
		return is_input(input, action)

	return set_input(input, action)

func ensure_key(key : Key, action : String) -> bool:
	if has_key(key):
		return is_key(key, action)

	return set_key(key, action)

func ensure_mouse_dir(dir : MOUSE_DIR, action : String) -> bool:
	if has_mouse_dir(dir):
		return is_mouse_dir(dir, action)

	return set_mouse_dir(dir, action)

func ensure_mouse_button(mouse_button : MouseButton, action : String) -> bool:
	if has_mouse_button(mouse_button):
		return is_mouse_button(mouse_button, action)

	return set_mouse_button(mouse_button, action)

func change_input(input : String, action : String) -> bool:
	return has_input(input) and set_input(input, action)

func change_key(key : Key, action : String) -> bool:
	return has_key(key) and set_key(key, action)

func change_mouse_dir(dir : MOUSE_DIR, action : String) -> bool:
	return has_mouse_dir(dir) and set_mouse_dir(dir, action)

func change_mouse_button(mouse_button : MouseButton, action : String) -> bool:
	return has_mouse_button(mouse_button) and set_mouse_button(mouse_button, action)

func add_action(action : String) -> bool:
	if has_action(action):
		return false

	actions[action] = InputAction.new()

	if not set_deadzone(action, default_deadzone):
		return false

	if not set_tap_threshold(action, default_tap_threshold):
		return false

	if not set_doubletap_threshold(action, default_doubletap_threshold):
		return false

	if not set_hold_threshold(action, default_hold_threshold):
		return false

	if not set_high_threshold(action, default_high_threshold):
		return false

	if not set_buffer_length(action, default_buffer_length):
		return false

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
