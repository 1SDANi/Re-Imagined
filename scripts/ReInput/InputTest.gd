extends Sprite2D

const SPEED : float = 100.0
const DASH_SPEED : float = 10000.0

func _ready() -> void:
	game.inputHandler.set_default_deadzone(0.25)
	game.inputHandler.set_default_tap_threshold(0.125)
	game.inputHandler.set_default_doubletap_threshold(0.25)
	game.inputHandler.set_default_high_threshold(0.5)
	game.inputHandler.set_default_hold_threshold(1.0)
	game.inputHandler.set_default_buffer_length(5)

	game.inputHandler.add_key(KEY_W, "Move Front")
	game.inputHandler.add_key(KEY_S, "Move Back")
	game.inputHandler.add_key(KEY_A, "Move Right")
	game.inputHandler.add_key(KEY_D, "Move Left")

func _process(delta: float) -> void:
	var move = Vector2( \
		game.inputHandler.get_axis_value_spacey("Move Left", \
			"Move Right", true), \
		game.inputHandler.get_axis_value_spacey("Move Back", \
			"Move Front", true))

	if game.inputHandler.was_action_tapped("Move Front"):
		translate(Vector2.UP * delta * DASH_SPEED)
		game.inputHandler.clear_action_history("Move Front")
		game.inputHandler.untap_action("Move Front")
	if game.inputHandler.was_action_tapped("Move Back"):
		translate(Vector2.DOWN  * delta * DASH_SPEED)
		game.inputHandler.clear_action_history("Move Back")
		game.inputHandler.untap_action("Move Back")
	if game.inputHandler.was_action_tapped("Move Right"):
		translate(Vector2.LEFT  * delta * DASH_SPEED)
		game.inputHandler.clear_action_history("Move Right")
		game.inputHandler.untap_action("Move Right")
	if game.inputHandler.was_action_tapped("Move Left"):
		translate(Vector2.RIGHT  * delta * DASH_SPEED)
		game.inputHandler.clear_action_history("Move Left")
		game.inputHandler.untap_action("Move Left")

	if move.x != 0.0 or move.y != 0.0:
		translate(move.normalized() * delta * SPEED)
		game.inputHandler.clear_action_histories(["Move Front", "Move Back", \
			"Move Right", "Move Left"])
