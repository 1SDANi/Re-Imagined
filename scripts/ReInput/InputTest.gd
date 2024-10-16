extends Sprite2D

const SPEED : float = 100.0
const DASH_SPEED : float = 5000.0

@export var move_export : Vector2

const MF : String = "Move Front"
const MB : String = "Move Back"
const MR : String = "Move Right"
const ML : String = "Move Left"
const MH : String = "Move Horizontal"
const MV : String = "Move Vertical"
const AXIS_TYPE : InputAxis.AxisType = InputAxis.AxisType.SPACEY
const BIAS_TYPE : InputAxis.BiasType = InputAxis.BiasType.POS

func _ready() -> void:
	game.input.set_default_deadzone(0.25)
	game.input.set_default_high_threshold(0.5)
	game.input.set_default_tap_threshold(1.125)
	game.input.set_default_axis_tap_threshold(1.125)
	game.input.set_default_axis_doubletap_threshold(3.0)
	game.input.set_default_doubletap_threshold(3.0)
	game.input.set_default_hold_threshold(3.0)
	game.input.set_default_buffer_length(5)
	game.input.set_default_axis_buffer_length(5)

	if not game.input.add_key(KEY_W, MF):
		print("failed to add input")
	if not game.input.add_key(KEY_S, MB):
		print("failed to add input")
	if game.input.add_axis(MV, AXIS_TYPE, BIAS_TYPE):
		pass
	if not game.input.bind_axis(MB, MV, false):
		pass
	if not game.input.bind_axis(MF, MV, true):
		pass

	if not game.input.add_key(KEY_D, MR):
		print("failed to add input")
	if not game.input.add_key(KEY_A, ML):
		print("failed to add input")
	if game.input.add_axis(MH, AXIS_TYPE, BIAS_TYPE):
		pass
	if not game.input.bind_axis(MR, MH, false):
		pass
	if not game.input.bind_axis(ML, MH, true):
		pass

func _process(delta: float) -> void:
	var horizontal : InputAxis = game.input.get_axis(MH)
	var vertical : InputAxis = game.input.get_axis(MV)
	var x : float = horizontal.get_state().value
	var y : float = vertical.get_state().value
	var move : Vector2 = Vector2(x, y)

	move_export = move

	if vertical.get_state().is_tapped or horizontal.get_state().is_tapped:
		var lastx : float = horizontal.statehistory[1].value
		var lasty : float = vertical.statehistory[1].value
		var last_move : Vector2 = Vector2(lastx, lasty)
		translate(last_move * delta * DASH_SPEED)

	if move.x != 0.0 or move.y != 0.0:
		translate(move.normalized() * delta * SPEED)
