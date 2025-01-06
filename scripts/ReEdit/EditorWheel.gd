class_name EditorWheel
extends CommandWheel

func _init(user : Actor, controller : EditorController) -> void:
	category = "Editor"
	var _commands : Array[Command] = \
	[
		EditorMenu.new(self, controller),
		MapMenu.new(self)
	]
	super(user, _commands)
