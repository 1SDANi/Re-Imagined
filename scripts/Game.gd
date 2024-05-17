extends Node

var slope_mesh : NodePath

var input : InputHandler

func _ready() -> void:
	input =  InputHandler.new()

	input.set_default_deadzone(0.25)
	input.set_default_tap_threshold(0.125)
	input.set_default_doubletap_threshold(0.25)
	input.set_default_high_threshold(0.5)
	input.set_default_hold_threshold(1.0)
	input.set_default_buffer_length(5)

func set_slope_mesh(path : NodePath) -> void:
	slope_mesh = path

func get_slope_mesh() -> SlopeMesh:
	return get_node(slope_mesh)

func _physics_process(delta: float) -> void:
	input.update_all(delta)

func _input(event):
	if event is InputEventMouseMotion:
		input.mouse_motion_event(event)
