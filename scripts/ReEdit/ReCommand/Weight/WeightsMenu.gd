class_name WeightsMenu
extends CommandMenu

func _init(_last : EditorMenu, _palette : EditorPalette) -> void:
	var _commands : Array[Command] = [
		WeightMenu.new("Weight 1: ", _palette.r, self, 0),
		WeightMenu.new("Weight 2: ", _palette.g, self, 1),
		WeightMenu.new("Weight 3: ", _palette.b, self, 2),
		WeightMenu.new("Weight 4: ", _palette.a, self, 3)
	]
	super("Weights", _last, _commands)
