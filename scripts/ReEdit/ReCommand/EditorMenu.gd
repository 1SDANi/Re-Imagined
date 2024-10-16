class_name EditorMenu
extends CommandMenu

var controller : EditorController

var dragging : bool
var selection : bool

var clipboard : MapTile

var start_pos : Vector3i
var end_pos : Vector3i

var tool_menu : ToolMenu
var mode_menu : ModeMenu
var shape_menu : ShapeMenu
var textures_menu : TexturesMenu
var detail_menu : DetailMenu

func _init(_last : CommandMenu, _controller : EditorController) -> void:
	controller = _controller

	_controller.editor = self
	category = "Editor"

	tool_menu = ToolMenu.new(self, _controller.initial_mode)
	mode_menu = ModeMenu.new(self, _controller.initial_mode)
	shape_menu = ShapeMenu.new(self, _controller.initial_model)
	textures_menu = TexturesMenu.new(self, controller.initial_texture_1, controller.initial_texture_2, controller.initial_texture_3, controller.initial_texture_4)
	detail_menu = DetailMenu.new(self, _controller.initial_rot, controller.initial_weight_r, controller.initial_weight_g, controller.initial_weight_b, controller.initial_weight_a)

	var _commands : Array[Command] = \
	[
		tool_menu,
		mode_menu,
		shape_menu,
		textures_menu,
		detail_menu
	]

	super("Level Editor", _last, _commands)
	game.command_update()

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

func get_mode() -> MapHandler.MODE:
	return mode_menu.index as MapHandler.MODE

func get_shape() -> float:
	return shape_menu.main

func get_model() -> String:
	return shape_menu.get_model()

func get_texture(channel : int) -> String:
	return textures_menu.get_texture(channel)

func get_weight(channel : int) -> float:
	return detail_menu.get_weight(channel)

func get_rotation() -> int:
	return detail_menu.rotation

func get_blend() -> Color:
	var weight0 : float = get_weight(0)
	var weight1 : float = get_weight(1)
	var weight2 : float = get_weight(2)
	var weight3 : float = get_weight(3)
	var total : float = weight0 + weight1 + weight2 + weight3

	return Color(weight0 / total, weight1 / total, weight2 / total, weight3 / total)

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
