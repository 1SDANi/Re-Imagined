class_name StrategyMenu
extends CommandMenu

func _init() -> void:
	name = "Strategy"
	commands = [
		DummyCommand.new("Todo")
	]
