class_name InputAxis

enum AxisType
{
	SPACEY,
	BIASED,
	CANCEL
}

enum BiasType
{
	POS,
	NEG
}

var statehistory : Array[InputState]

var positive : InputAction
var negative : InputAction

var axis_type : AxisType
var bias_type : BiasType

var tap_threshold : float
var doubletap_threshold : float

var buffer_length : int

const nil_print_switch  : bool = false
const print_switch  : bool = false

func _init(axis: AxisType, bias: BiasType) -> void:
	axis_type = axis
	bias_type = bias
	var state : InputState = InputState.new(0.0)
	state.is_zero = true
	statehistory.push_front(state)

func update_axis(_delta : float) -> void:
	positive = null
	negative = null

func update_action(delta : float, _positive : bool, action : InputAction) -> void:
	if _positive:
		positive = action
	else:
		negative = action

	if positive != null and negative != null:
		match(axis_type):
			AxisType.SPACEY:
				update_spacey(positive.get_state(), negative.get_state(), delta)
			AxisType.BIASED:
				update_biased(positive.get_state(), negative.get_state(), delta)
			AxisType.CANCEL:
				update_cancel(positive.get_state(), negative.get_state(), delta)
		positive = null
		negative = null

func update_spacey(pos : InputState, neg : InputState, delta : float) -> void:
	var pos_younger : bool = pos.duration < neg.duration
	var neg_younger : bool = neg.duration < pos.duration
	var both_zero : bool = pos.is_zero and neg.is_zero

	if is_equal_approx(pos.duration, neg.duration) and not both_zero:
		statehistory[0].duration += delta
	elif not pos.is_zero and (pos_younger or neg.is_zero):
		push_state(pos, delta, false, "positive is older")
	elif not neg.is_zero and (neg_younger or pos.is_zero):
		push_state(neg, delta, true, "negative is older")
	else: update_biased(pos, neg, delta)

func update_biased(pos : InputState, neg : InputState, delta : float) -> void:
	var pos_bias : bool = bias_type == BiasType.POS
	var neg_bias : bool = bias_type == BiasType.NEG

	if not pos.is_zero and pos_bias:
		push_state(pos, delta, false, "positive is biased")
	elif not neg.is_zero and neg_bias:
		push_state(neg, delta, true, "negative is biased")
	else: push_nil(delta, "of empty input")

func update_cancel(pos : InputState, neg : InputState, delta : float) -> void:
	if pos.is_zero == neg.is_zero and not pos.is_zero:
		push_nil(delta, "of canceled input")
	elif neg.is_zero:
		push_state(pos, delta, false, "negative is zero")
	elif pos.is_zero:
		push_state(neg, delta, true, "positive is zero")
	else: push_nil(delta, "of empty input")

func clear_history() -> void:
	if statehistory.size() > 1:
		if statehistory.resize(1) != OK:
			print("failed to clear history")

func get_state() -> InputState:
	return statehistory[0]

func get_average() -> float:
	return positive.get_average() - negative.get_average()

func push_nil(delta : float, r : String) -> void:
	var last_duration : float = statehistory[0].duration
	if statehistory[0].is_zero: last_duration += delta

	if statehistory.size() >= buffer_length:
		statehistory.pop_back()

	var state : InputState = InputState.new(0.0)

	state.is_zero = true

	if statehistory.size() > 1:
		if not statehistory[0].is_zero and statehistory[0].is_high:
			state.is_dropped = true

		if not statehistory[0].is_zero and last_duration >= tap_threshold:
			state.is_pressed = true

		if not statehistory[0].is_zero and last_duration < tap_threshold:
			state.is_tapped = true
			print(last_duration)
			print(tap_threshold)

		if statehistory.size() > 2:
			if statehistory[0].is_tapped and statehistory[2].is_tapped:
				statehistory[0].is_doubletapped = true

	statehistory.push_front(state)

	if nil_print_switch:
		print("stopping  because " + r)

func push_state(state : InputState, del : float, n : bool, r : String) -> void:
	var same_direction : bool = statehistory[0].value < 0 == n
	var same_highness : bool = statehistory[0].is_high == state.is_high
	var same_nillness : bool = statehistory[0].is_zero == state.is_zero

	if same_highness and same_nillness and same_direction:
		statehistory[0].duration += del
	else:
		if statehistory.size() >= buffer_length:
			statehistory.pop_back()

		if print_switch:
			print("switching to " + str(n) + " because " + str(r))

		var clone : InputState = InputState.new(0.0)

		clone.clone(state)
		statehistory.push_front(clone)

		statehistory[0].duration = 1.0
		statehistory[0].value = state.value * (-1.0 if n else 1.0)
