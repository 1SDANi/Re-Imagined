class_name EditorWheel
extends CommandWheel

var editor : EditorMenu
var map : MapMenu

func _init(user : Actor, controller : EditorController) -> void:
	category = "Editor"

	controller.editor = self
	editor = EditorMenu.new(self, controller)
	map = MapMenu.new(self)

	var _commands : Array[Command] = \
	[
		editor,
		map
	]
	super(user, _commands)
