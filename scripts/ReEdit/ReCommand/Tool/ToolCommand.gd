class_name ToolCommand
extends Command

var tool : MapHandler.TOOL

func _init(_last : ToolMenu, _tool : MapHandler.TOOL) -> void:
	tool = _tool
	category = MapHandler.TOOL_NAMES[_tool]
	super(MapHandler.TOOL_NAMES[_tool], _last)

func copy(pos : Vector3i) -> void:
	var editor : EditorMenu = last.last
	var mode : MapHandler.MODE = editor.get_mode()
	var mesh : VoxelMesh = game.get_mode_mesh(mode)
	var ind : int
	var indices : Vector4i
	var texw : String
	var texx : String
	var texy : String
	var texz : String
	var texcol : Color
	var start : Vector3i = abs((last.last as EditorMenu).start_pos)
	var x : int = start.x - pos.x
	var y : int = start.y - pos.y
	var z : int = start.z - pos.z
	var cb : MapTile = (last.last as EditorMenu).clipboard
	match(mode):
		MapHandler.MODE.SLOPE:
			mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
			cb.slope_geo.layers[x].rows[y].geo[z] = mesh.tool.get_voxel_f(pos)
			mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
			ind = mesh.tool.get_voxel(start)
			indices = VoxelTool.u16_indices_to_vec4i(ind)
			texw = game.map.get_texture_name(indices.w)
			texx = game.map.get_texture_name(indices.x)
			texy = game.map.get_texture_name(indices.y)
			texz = game.map.get_texture_name(indices.x)
			cb.slope_tex.w[x].rows[y].tex[z] = texw
			cb.slope_tex.x[x].rows[y].tex[z] = texx
			cb.slope_tex.y[x].rows[y].tex[z] = texy
			cb.slope_tex.z[x].rows[y].tex[z] = texz
			mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
			ind = mesh.tool.get_voxel(pos)
			texcol = VoxelTool.u16_weights_to_color(ind)
			cb.slope_tex.col[x].rows[y].col[z] = texcol
		MapHandler.MODE.SMOOTH:
			mesh.tool.channel = VoxelBuffer.CHANNEL_SDF
			cb.smooth_geo.layers[x].rows[y].geo[z] = mesh.tool.get_voxel_f(pos)
			mesh.tool.channel = VoxelBuffer.CHANNEL_INDICES
			indices = VoxelTool.u16_indices_to_vec4i(ind)
			texw = game.map.get_texture_name(indices.w)
			texx = game.map.get_texture_name(indices.x)
			texy = game.map.get_texture_name(indices.y)
			texz = game.map.get_texture_name(indices.x)
			cb.smooth_tex.w[x].rows[y].tex[z] = texw
			cb.smooth_tex.x[x].rows[y].tex[z] = texx
			cb.smooth_tex.y[x].rows[y].tex[z] = texy
			cb.smooth_tex.z[x].rows[y].tex[z] = texz
			mesh.tool.channel = VoxelBuffer.CHANNEL_COLOR
			ind = mesh.tool.get_voxel(pos)
			texcol = VoxelTool.u16_weights_to_color(ind)
			cb.smooth_tex.col[x].rows[y].col[z] = texcol
		MapHandler.MODE.MODEL:
			mesh.tool.channel = VoxelBuffer.CHANNEL_TYPE
			cb.model_vox.layers[x].rows[y].vox[z] = mesh.tool.get_voxel(pos)

func loop(start : Vector3i, end : Vector3i, _call : Callable) -> void:
	var r : int = 1
	var s : int = 1
	var t : int = 1
	var i : int = end.x - start.x
	var j : int = end.y - start.y
	var k : int = end.z - start.z
	var p : Vector3i
	if i < 0:
		i = -i
		r = -r
	if j < 0:
		j = -j
		s = -s
	if k < 0:
		k = -k
		t = -t
	var a : int
	var b : int
	var c : int
	for x : int in range(i + 1):
		for y : int in range(j + 1):
			for z : int in range(k + 1):
				a = start.x + x * r
				b = start.y + y * s
				c = start.z + z * t
				p = Vector3i(a, b, c)
				_call.call(p)
