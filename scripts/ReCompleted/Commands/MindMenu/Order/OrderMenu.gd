class_name OrderMenu
extends CommandMenu

func _init() -> void:
	name = "Order"
	commands = [
		DummyCommand.new("Todo")
	]
