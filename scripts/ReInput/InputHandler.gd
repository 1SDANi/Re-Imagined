class_name InputHandler

enum InputMode
{
	KBM,
	GMP
}

enum ACTION_MODE
{
	WORLD,
	POPUP
}

enum MOUSE_DIR
{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

const WHEEL_DIR : Array[int] = \
[
	MouseButton.MOUSE_BUTTON_WHEEL_UP,
	MouseButton.MOUSE_BUTTON_WHEEL_DOWN
]

const MOUSE_DIR_NAMES : Array[String] = [ "Up", "Down", "Left", "Right" ]

var gmp : Dictionary
var kbm : Dictionary
var mod : Dictionary
var mob : Dictionary
var actions : Dictionary
var axes : Dictionary

var default_deadzone: float
var default_tap_threshold : float
var default_axis_tap_threshold : float
var default_high_threshold : float
var default_hold_threshold : float
var default_doubletap_threshold : float
var default_axis_doubletap_threshold : float

var mouse_motion : Vector2
var wheel_motion : float

var default_buffer_length : int
var default_axis_buffer_length : int

var cam_speed_x : float
var cam_speed_y : float

var input_mode : InputMode

var action_mode : ACTION_MODE

func set_input_mode(mode: InputMode) -> void:
	input_mode = mode

func set_action_mode(mode: ACTION_MODE) -> void:
	if mode == ACTION_MODE.POPUP and not is_mouse_free(): release_mouse()
	if mode == ACTION_MODE.WORLD and is_mouse_free(): capture_mouse()
	action_mode = mode
	game.command_update()

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
	game.command_update()

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	game.command_update()

func toggle_mouse_capture() -> void:
	if is_mouse_captured():
		release_mouse()
	else:
		capture_mouse()

func update_actions(delta : float) -> void:
	update_inputs(delta)
	update_keys(delta)
	update_mouse_dir(delta)
	update_mouse_buttons(delta)

func update_inputs(delta : float) -> void:
	if input_mode != InputMode.GMP: return
	for input : String in gmp:
		var i : InputAction = actions[gmp[input]]
		i.update(Input.get_action_strength(input), delta)

func update_keys(delta : float) -> void:
	if input_mode != InputMode.KBM: return
	for action : Key in kbm:
		var a : InputAction = actions[kbm[action]]
		a.update(Input.is_key_pressed(action), delta)

func update_mouse_buttons(delta : float) -> void:
	if input_mode != InputMode.KBM: return
	for action : MouseButton in mob:
		if action in WHEEL_DIR: continue
		var a : InputAction = actions[mob[action]]
		a.update(Input.is_mouse_button_pressed(action), delta)

	var up : float = wheel_motion if wheel_motion > 0.0 else 0.0
	var down : float = -wheel_motion if wheel_motion < 0.0 else 0.0

	var up_a : InputAction = actions[mob[MouseButton.MOUSE_BUTTON_WHEEL_UP]]
	var down_a : InputAction = actions[mob[MouseButton.MOUSE_BUTTON_WHEEL_DOWN]]

	up_a.update(up, delta)
	down_a.update(down, delta)

	wheel_motion = 0.0

func update_mouse_dir(delta : float) -> void:
	if input_mode != InputMode.KBM: return
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
	if input_mode != InputMode.KBM: return
	if event is InputEventMouseButton:
		var e : InputEventMouseButton = event
		if e.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
			wheel_motion = 1.0
		elif e.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
			wheel_motion = -1.0

func mouse_motion_event(event : InputEvent) -> void:
	if input_mode != InputMode.KBM: return
	if event is InputEventMouseMotion:
		var e : InputEventMouseMotion = event
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if e.relative.x != 0:
				mouse_motion.x = e.relative.x
			if e.relative.y != 0:
				mouse_motion.y = e.relative.y

func get_axis(axis : String) -> InputAxis:
	if not has_axis(axis):
		return null

	var a : InputAxis = axes[axis]

	return a

func get_action(action : String) -> InputAction:
	if not has_action(action):
		return null

	var a : InputAction = actions[action]

	return a

func get_axis_state(axis : String) -> InputState:
	if not has_axis(axis):
		return null

	var a : InputAxis = axes[axis]

	return a.get_state()

func get_state(action : String) -> InputState:
	if not has_action(action):
		return null

	var a : InputAction = actions[action]

	return a.get_state()

func clear_action_history(action : String) -> void:
	var a : InputAction = actions[action]
	a.clear_history()

func clear_action_histories(_actions : Array[String]) -> void:
	for action : String in _actions:
		clear_action_history(action)

func clear_axis_history(axis : String) -> void:
	var a : InputAxis = axes[axis]
	a.clear_history()

func clear_axis_histories(_axes : Array[String]) -> void:
	for axis : String in _axes:
		clear_action_history(axis)

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

func has_axis(axis : String) -> bool:
	return axes.has(axis)

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
		print(str(input) + " already assigned to an action")
		return false

	if not set_input(input, action):
		print("failed to set " + input + " to " + action)
		return false

	if not has_action(action) and not add_action(action):
		print("failed to add action " + action)
		return false

	return true

func add_key(key : Key, action : String) -> bool:
	if has_key(key):
		print("Key " + str(key) + " already assigned to an action")
		return false

	if not set_key(key, action):
		print("failed to set " + str(key) + " to " + action)
		return false

	if not has_action(action) and not add_action(action):
		print("failed to add action " + action)
		return false

	return true

func add_mouse_dir(dir : MOUSE_DIR, action : String) -> bool:
	if has_mouse_dir(dir):
		print("mouse " + MOUSE_DIR_NAMES[dir] + " already assigned to an action")
		return false

	if not set_mouse_dir(dir, action):
		print("failed to set mouse " + MOUSE_DIR_NAMES[dir] + " to " + action)
		return false

	if not has_action(action) and not add_action(action):
		print("failed to add action " + action)
		return false

	return true

func add_mouse_button(mouse_button : MouseButton, action : String) -> bool:
	if has_mouse_button(mouse_button):
		print("Key " + str(mouse_button) + " already assigned to an action")
		return false

	if not set_mouse_button(mouse_button, action):
		print("failed to set " + str(mouse_button) + " to " + action)
		return false

	if not has_action(action) and not add_action(action):
		print("failed to add action " + action)
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

func add_axis(name : String, axis : InputAxis.AxisType, bias : InputAxis.BiasType) -> bool:
	axes[name] = InputAxis.new(axis, bias)

	if not set_axis_buffer_length(name, default_axis_buffer_length):
		return false

	if not set_axis_doubletap_threshold(name, default_axis_doubletap_threshold):
		return false

	if not set_axis_tap_threshold(name, default_axis_tap_threshold):
		return false

	return true

func bind_axis(action : String, axis : String, pos : bool) -> bool:
	if not has_action(action):
		return false

	if not has_axis(axis):
		return false

	var a : InputAction = actions[action]
	var x : InputAxis = axes[axis]

	return a.bind_axis(x, pos)

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

func set_axis_tap_threshold(axis: String, tap_threshold : float) -> bool:
	if not has_axis(axis):
		return false

	axes[axis].tap_threshold = tap_threshold
	return true

func set_default_tap_threshold(tap_threshold : float) -> void:
	default_tap_threshold = tap_threshold

func set_default_axis_tap_threshold(tap_threshold : float) -> void:
	default_axis_tap_threshold = tap_threshold

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

func set_axis_doubletap_threshold(axis: String, doubletap_threshold : float) -> bool:
	if not has_axis(axis):
		return false

	axes[axis].doubletap_threshold = doubletap_threshold

	return true

func set_default_doubletap_threshold(doubletap_threshold : float) -> void:
	default_doubletap_threshold = doubletap_threshold

func set_default_axis_doubletap_threshold(doubletap_threshold : float) -> void:
	default_axis_doubletap_threshold = doubletap_threshold

func set_buffer_length(action: String, buffer_length : int) -> bool:
	if not has_action(action):
		return false

	actions[action].buffer_length = buffer_length

	return true

func set_axis_buffer_length(axis: String, buffer_length : int) -> bool:
	if not has_axis(axis):
		return false

	axes[axis].buffer_length = buffer_length

	return true

func set_default_buffer_length(buffer_length : int) -> void:
	default_buffer_length = buffer_length

func set_default_axis_buffer_length(buffer_length : int) -> void:
	default_axis_buffer_length = buffer_length
