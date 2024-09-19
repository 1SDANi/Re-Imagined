class_name EditorMenu
extends CommandMenu

var controller : EditorController

var mode_commands : Array[Array]

var model_shape : String

var model_rot : int

var mode : MapHandler.MODE

var palette : EditorPalette

var dragging : bool
var selection : bool

var clipboard : MapTile

var start_pos : Vector3i
var end_pos : Vector3i

func _init(_last : CommandMenu, _controller : EditorController) -> void:
	controller = _controller

	model_shape = _controller.initial_model
	model_rot = _controller.initial_rot
	mode = _controller.initial_mode

	var _palette : EditorPalette = EditorPalette.new(\
		_controller.initial_texture_1, \
		_controller.initial_texture_2, _controller.initial_texture_3, \
		_controller.initial_texture_4, _controller.initial_weight_r, \
		_controller.initial_weight_g, _controller.initial_weight_b, \
		_controller.initial_weight_a, _controller.initial_smooth_value, \
		_controller.initial_slope_value)
	palette = _palette
	game.palette = palette

	mode_commands = [[], [], []]

	var smooth_commands : Array[Command] = \
	[
		ToolMenu.new(self),
		ModeMenu.new(self),
		ShapeMenu.new(self),
		TexturesMenu.new(self, _palette),
		WeightsMenu.new(self, _palette)
	]

	var slope_commands : Array[Command] = \
	[
		ToolMenu.new(self),
		ModeMenu.new(self),
		ShapeMenu.new(self),
		TexturesMenu.new(self, _palette),
		WeightsMenu.new(self, _palette)
	]
	var model_commands : Array[Command] = \
	[
		ToolMenu.new(self),
		ModeMenu.new(self),
		ShapeMenu.new(self),
		TexturesMenu.new(self, _palette),
		RotationMenu.new(self)
	]

	mode_commands[MapHandler.MODE.SMOOTH] = smooth_commands
	mode_commands[MapHandler.MODE.SLOPE] = slope_commands
	mode_commands[MapHandler.MODE.MODEL] = model_commands

	super("Level Editor", _last, mode_commands[mode])

func update_commands() -> void:
	super()

func set_mode(_mode : MapHandler.MODE) -> void:
	mode = _mode
	game.mode = _mode
	commands = mode_commands[_mode]
	update_commands()

func new_clipboard(_x : int, _y : int, _z : int) -> void:
	clipboard = MapTile.new()
	for x : int in range(_x + 1):
		clipboard.slope_geo.layers.append([])
		clipboard.slope_tex.w.append([])
		clipboard.slope_tex.x.append([])
		clipboard.slope_tex.y.append([])
		clipboard.slope_tex.z.append([])
		clipboard.slope_tex.col.append([])
		clipboard.smooth_geo.layers.append([])
		clipboard.smooth_tex.w.append([])
		clipboard.smooth_tex.x.append([])
		clipboard.smooth_tex.y.append([])
		clipboard.smooth_tex.z.append([])
		clipboard.smooth_tex.col.append([])
		clipboard.model_vox.layers.append([])
		for y : int in range(_y + 1):
			clipboard.slope_geo.layers[x].rows.append([])
			clipboard.slope_tex.w[x].rows.append([])
			clipboard.slope_tex.x[x].rows.append([])
			clipboard.slope_tex.y[x].rows.append([])
			clipboard.slope_tex.z[x].rows.append([])
			clipboard.slope_tex.col[x].rows.append([])
			clipboard.smooth_geo.layers[x].rows.append([])
			clipboard.smooth_tex.w[x].rows.append([])
			clipboard.smooth_tex.x[x].rows.append([])
			clipboard.smooth_tex.y[x].rows.append([])
			clipboard.smooth_tex.z[x].rows.append([])
			clipboard.smooth_tex.col[x].rows.append([])
			clipboard.model_vox.layers[x].rows.append([])
			for z : int in range(_z + 1):
				clipboard.slope_geo.layers[x].rows[y].geo.append(1.0)
				clipboard.slope_tex.w[x].rows[y].tex.append("")
				clipboard.slope_tex.x[x].rows[y].tex.append("")
				clipboard.slope_tex.y[x].rows[y].tex.append("")
				clipboard.slope_tex.z[x].rows[y].tex.append("")
				clipboard.slope_tex.col[x].rows[y].col.append("")
				clipboard.smooth_geo.layers[x].rows[y].geo.append(1.0)
				clipboard.smooth_tex.w[x].rows[y].tex.append("")
				clipboard.smooth_tex.x[x].rows[y].tex.append("")
				clipboard.smooth_tex.y[x].rows[y].tex.append("")
				clipboard.smooth_tex.z[x].rows[y].tex.append("")
				clipboard.smooth_tex.col[x].rows[y].col.append("")
				clipboard.model_vox.layers[x].rows[y].vox.append(0)

func set_rot(_rot : int) -> void:
	model_rot = _rot
	update_commands()

func set_model_shape(_model_shape : String) -> void:
	model_shape = _model_shape
	update_commands()

func set_slope_value(_slope_value : float) -> void:
	palette.slope_value = _slope_value
	update_commands()

func add_slope_value(_slope_value : float) -> void:
	set_slope_value(palette.slope_value + _slope_value)

func sub_slope_value(_slope_value : float) -> void:
	set_slope_value(palette.slope_value - _slope_value)

func set_smooth_value(_smooth_value : float) -> void:
	palette.smooth_value = _smooth_value
	update_commands()

func add_smooth_value(_smooth_value : float) -> void:
	set_smooth_value(palette.smooth_value + _smooth_value)

func sub_smooth_value(_smooth_value : float) -> void:
	set_smooth_value(palette.smooth_value - _smooth_value)

func get_texture(channel : int) -> String:
	match (channel):
		0:
			return palette.w
		1:
			return palette.x
		2:
			return palette.y
		3:
			return palette.z
		_:
			return "ERROR"

func set_texture(channel : int, texture : String) -> void:
	match (channel):
		0:
			palette.x = palette.w if palette.x == texture else palette.x
			palette.y = palette.w if palette.y == texture else palette.y
			palette.z = palette.w if palette.z == texture else palette.z
			palette.w = texture
		1:
			palette.w = palette.w if palette.w == texture else palette.w
			palette.y = palette.w if palette.y == texture else palette.y
			palette.z = palette.w if palette.z == texture else palette.z
			palette.x = texture
		2:
			palette.w = palette.w if palette.w == texture else palette.w
			palette.x = palette.w if palette.x == texture else palette.x
			palette.z = palette.w if palette.z == texture else palette.z
			palette.y = texture
		3:
			palette.w = palette.w if palette.w == texture else palette.w
			palette.x = palette.w if palette.x == texture else palette.x
			palette.y = palette.w if palette.y == texture else palette.y
			palette.z = texture
	update_commands()
	game.palette = palette

func get_weight(channel : int) -> float:
	match (channel):
		0:
			return palette.r
		1:
			return palette.g
		2:
			return palette.b
		3:
			return palette.a
		_:
			return NAN

func set_weight(channel : int, weight : float) -> void:
	match (channel):
		0:
			palette.r = weight
		1:
			palette.g = weight
		2:
			palette.b = weight
		3:
			palette.a = weight
	update_commands()
	game.palette = palette

func add_weight(channel : int, change : float) -> void:
	set_weight(channel, get_weight(channel) + change)

func sub_weight(channel : int, change : float) -> void:
	set_weight(channel, get_weight(channel) - change)

func get_blend() -> void:
	return Color(get_weight(0), get_weight(1), get_weight(2), get_weight(3))

func select_start(targeti : Vector3i) -> void:
	start_pos = targeti
	dragging = true
	controller.select_start(targeti)

func select_end(targeti : Vector3i) -> void:
	end_pos = targeti
	selection = true
	dragging = false
	controller.select_end(targeti)
	print("select end")

func deselect() -> void:
	selection = false
	dragging = false
	controller.deselect()
	print("deselect")
