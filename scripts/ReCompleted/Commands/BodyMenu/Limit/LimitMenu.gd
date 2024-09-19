class_name LimitMenu
extends CommandMenu

func _init() -> void:
	name = "Limit"
	commands = [
		DummyCommand.new("Ars Arcanum"),
		DummyCommand.new("Ragnarok"),
		DummyCommand.new("Solo Limit")
	]
