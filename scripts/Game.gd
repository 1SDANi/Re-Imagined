extends Node

var inputHandler : InputHandler

func _ready() -> void:
	inputHandler =  InputHandler.new()

	inputHandler.set_default_deadzone(0.25)
	inputHandler.set_default_tap_threshold(0.125)
	inputHandler.set_default_doubletap_threshold(0.25)
	inputHandler.set_default_high_threshold(0.5)
	inputHandler.set_default_hold_threshold(1.0)
	inputHandler.set_default_buffer_length(5)

func _physics_process(delta: float) -> void:
	inputHandler.update_all(delta)

func _input(event):
	if event is InputEventMouseMotion:
		inputHandler.mouse_motion_event(event)
