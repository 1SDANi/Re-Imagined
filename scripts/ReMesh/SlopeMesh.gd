extends VoxelTerrain
class_name SlopeMesh

const NNN : int = 1 << 0
const ZNN : int = 1 << 1
const PNN : int = 1 << 2
const NZN : int = 1 << 3
const ZZN : int = 1 << 4
const PZN : int = 1 << 5
const NPN : int = 1 << 6
const ZPN : int = 1 << 7
const PPN : int = 1 << 8
const NNZ : int = 1 << 9
const ZNZ : int = 1 << 10
const PNZ : int = 1 << 11
const NZZ : int = 1 << 12
const ZZZ : int = 1 << 13
const PZZ : int = 1 << 14
const NPZ : int = 1 << 15
const ZPZ : int = 1 << 16
const PPZ : int = 1 << 17
const NNP : int = 1 << 18
const ZNP : int = 1 << 19
const PNP : int = 1 << 20
const NZP : int = 1 << 21
const ZZP : int = 1 << 22
const PZP : int = 1 << 23
const NPP : int = 1 << 24
const ZPP : int = 1 << 25
const PPP : int = 1 << 26

var tool : VoxelTool

enum ROT
{
	UP_FRONT,
	UP_BACK,
	UP_LEFT,
	UP_RIGHT,
	DOWN_FRONT,
	DOWN_BACK,
	DOWN_LEFT,
	DOWN_RIGHT,
}

func _ready() -> void:
	game.set_slope_mesh(get_path())
	tool = get_voxel_tool()

func _get_shape(name : String, rot : ROT):
	return mesher.library.get_model_index_single_attribute(name, rot)

func place(pos : Vector3i) -> void:
	tool.channel = VoxelBuffer.CHANNEL_TYPE
	var voxel : int = tool.get_voxel(pos)

	if voxel <= 0:
		tool.set_voxel(pos, _get_shape("block", 0))
		#tool.set_voxel(pos, 1)
		shapes(pos)
	else:
		tool.set_voxel(pos, 0)
		#tool.set_voxel(pos, 0)
		shapes(pos)

func shapes(pos : Vector3i) -> void:
	for x in range(-1,2):
		for y in range(-1,2):
			for z in range(-1,2):
				shape(pos + Vector3i(x, y, z))

func shape(pos : Vector3i) -> void:
	tool.channel = VoxelBuffer.CHANNEL_TYPE
	var voxel : int = tool.get_voxel(pos)
	#var data : Variant = tool.get_voxel_metadata(pos)
	var mask : int = 0
	for x in range(-1,2):
		for y in range(-1,2):
			for z in range(-1,2):
				var magic : int = (z + 2) + (y * 3 + 2) + (x * 9 + 2) + 7
				var check : Vector3i = pos + Vector3i(x, y, z)
				mask |= int(tool.get_voxel(check) > 0) << magic

	if voxel > 0:
		var zzp : bool = mask & ZZP > 0
		var pzz : bool = mask & PZZ > 0
		var zzn : bool = mask & ZZN > 0
		var nzz : bool = mask & NZZ > 0
		var znz : bool = mask & ZNZ > 0
		var zpz : bool = mask & ZPZ > 0
		var pzp : bool = mask & PZP > 0
		var pzn : bool = mask & PZN > 0
		var nzp : bool = mask & NZP > 0
		var nzn : bool = mask & NZN > 0

		if zzp and zzn and pzz and nzz and pzp and pzn and nzp and nzn:
			tool.set_voxel(pos, _get_shape("block", 0))
		elif znz and not zpz:
			top_shape(pos, mask)
		elif not znz and zpz:
			bottom_shape(pos, mask)
		elif not (znz and zpz):
			side_shape(pos, mask)
		else:
			tool.set_voxel(pos, _get_shape("block", 0))

func side_shape(pos : Vector3i, mask : int):
	var zzp : bool = mask & ZZP > 0
	var pzz : bool = mask & PZZ > 0
	var zzn : bool = mask & ZZN > 0
	var nzz : bool = mask & NZZ > 0
	var pzp : bool = mask & PZP > 0
	var pzn : bool = mask & PZN > 0
	var nzp : bool = mask & NZP > 0
	var nzn : bool = mask & NZN > 0
	var zpp : bool = mask & ZPP > 0
	var ppz : bool = mask & PPZ > 0
	var zpn : bool = mask & ZPN > 0
	var npz : bool = mask & NPZ > 0
	var ppp : bool = mask & PPP > 0
	var ppn : bool = mask & PPN > 0
	var npp : bool = mask & NPP > 0
	var npn : bool = mask & NPN > 0
	var znp : bool = mask & ZNP > 0
	var pnz : bool = mask & PNZ > 0
	var znn : bool = mask & ZNN > 0
	var nnz : bool = mask & NNZ > 0
	var pnp : bool = mask & PNP > 0
	var pnn : bool = mask & PNN > 0
	var nnp : bool = mask & NNP > 0
	var nnn : bool = mask & NNN > 0

	if zzn and zpn and znn:
		tool.set_voxel(pos, _get_shape("spire", 1))
	elif zzp and zpp and znp:
		tool.set_voxel(pos, _get_shape("spire", 3))
	elif pzz and ppz and pnz:
		tool.set_voxel(pos, _get_shape("spire", 4))
	elif nzz and npz and nnz:
		tool.set_voxel(pos, _get_shape("spire", 6))
	elif zzp and zpp:
		tool.set_voxel(pos, _get_shape("hang", 2))
	elif zzn and zpn:
		tool.set_voxel(pos, _get_shape("hang", 8))
	elif pzz and ppz:
		tool.set_voxel(pos, _get_shape("hang", 18))
	elif nzz and npz:
		tool.set_voxel(pos, _get_shape("hang", 20))
	elif zzn and znn:
		tool.set_voxel(pos, _get_shape("hang", 0))
	elif zzp and znp:
		tool.set_voxel(pos, _get_shape("hang", 10))
	elif nzz and nnz:
		tool.set_voxel(pos, _get_shape("hang", 16))
	elif pzz and pnz:
		tool.set_voxel(pos, _get_shape("hang", 22))
	else:
		tool.set_voxel(pos, _get_shape("block", 0))

func top_shape(pos : Vector3i, mask : int):
	var zzp : bool = mask & ZZP > 0
	var pzz : bool = mask & PZZ > 0
	var zzn : bool = mask & ZZN > 0
	var nzz : bool = mask & NZZ > 0
	var pzp : bool = mask & PZP > 0
	var pzn : bool = mask & PZN > 0
	var nzp : bool = mask & NZP > 0
	var nzn : bool = mask & NZN > 0

	if zzp and pzz and zzn and nzz and nzp and nzn and pzn:
		tool.set_voxel(pos, _get_shape("heartfork", 0))
	elif zzp and pzz and zzn and nzz and pzn and pzp and nzp:
		tool.set_voxel(pos, _get_shape("heartfork", 10))
	elif zzp and pzz and zzn and nzz and pzp and nzp and nzn:
		tool.set_voxel(pos, _get_shape("heartfork", 16))
	elif zzp and pzz and zzn and nzz and nzn and pzn and pzp:
		tool.set_voxel(pos, _get_shape("heartfork", 22))
	elif zzp and pzz and zzn and nzz and pzn and pzp:
		tool.set_voxel(pos, _get_shape("macefork", 0))
	elif zzp and pzz and zzn and nzz and nzp and nzn:
		tool.set_voxel(pos, _get_shape("macefork", 10))
	elif zzp and pzz and zzn and nzz and nzn and pzn:
		tool.set_voxel(pos, _get_shape("macefork", 16))
	elif zzp and pzz and zzn and nzz and pzp and nzp:
		tool.set_voxel(pos, _get_shape("macefork", 22))
	elif zzp and pzz and zzn and nzz and pzn and nzp:
		tool.set_voxel(pos, _get_shape("bowfork", 0))
	elif zzp and pzz and zzn and nzz and nzn and pzp:
		tool.set_voxel(pos, _get_shape("bowfork", 16))
	elif zzp and pzz and zzn and nzz and pzn:
		tool.set_voxel(pos, _get_shape("fishfork", 0))
	elif zzp and pzz and zzn and nzz and nzp:
		tool.set_voxel(pos, _get_shape("fishfork", 10))
	elif zzp and pzz and zzn and nzz and nzn:
		tool.set_voxel(pos, _get_shape("fishfork", 16))
	elif zzp and pzz and zzn and nzz and pzp:
		tool.set_voxel(pos, _get_shape("fishfork", 22))
	elif zzp and pzz and zzn and nzz:
		tool.set_voxel(pos, _get_shape("xfork", 0))
	elif zzp and pzz and zzn and pzp and pzn:
		tool.set_voxel(pos, _get_shape("slope", 0))
	elif zzp and zzn and nzz and nzp and nzn:
		tool.set_voxel(pos, _get_shape("slope", 10))
	elif pzz and zzn and nzz and pzn and nzn:
		tool.set_voxel(pos, _get_shape("slope", 16))
	elif zzp and pzz and nzz and pzp and nzp:
		tool.set_voxel(pos, _get_shape("slope", 22))
	elif zzp and pzz and zzn and pzp:
		tool.set_voxel(pos, _get_shape("pfork", 0))
	elif zzp and zzn and nzz and nzn:
		tool.set_voxel(pos, _get_shape("pfork", 10))
	elif pzz and zzn and nzz and pzn:
		tool.set_voxel(pos, _get_shape("pfork", 16))
	elif zzp and pzz and nzz and nzp:
		tool.set_voxel(pos, _get_shape("pfork", 22))
	elif zzp and pzz and zzn and pzn:
		tool.set_voxel(pos, _get_shape("qfork", 0))
	elif zzp and zzn and nzz and nzp:
		tool.set_voxel(pos, _get_shape("qfork", 10))
	elif pzz and zzn and nzz and nzn:
		tool.set_voxel(pos, _get_shape("qfork", 16))
	elif zzp and pzz and nzz and pzp:
		tool.set_voxel(pos, _get_shape("qfork", 22))
	elif zzp and pzz and zzn:
		tool.set_voxel(pos, _get_shape("tfork", 0))
	elif zzp and zzn and nzz:
		tool.set_voxel(pos, _get_shape("tfork", 10))
	elif pzz and zzn and nzz:
		tool.set_voxel(pos, _get_shape("tfork", 16))
	elif zzp and pzz and nzz:
		tool.set_voxel(pos, _get_shape("tfork", 22))
	elif zzp and nzz and nzp:
		tool.set_voxel(pos, _get_shape("corner", 0))
	elif zzn and pzz and pzn:
		tool.set_voxel(pos, _get_shape("corner", 10))
	elif zzp and pzz and pzp:
		tool.set_voxel(pos, _get_shape("corner", 16))
	elif zzn and nzz and nzn:
		tool.set_voxel(pos, _get_shape("corner", 22))
	elif zzp and nzz:
		tool.set_voxel(pos, _get_shape("lfork", 0))
	elif pzz and zzn:
		tool.set_voxel(pos, _get_shape("lfork", 10))
	elif zzp and pzz:
		tool.set_voxel(pos, _get_shape("lfork", 16))
	elif zzn and nzz:
		tool.set_voxel(pos, _get_shape("lfork", 22))
	elif zzp and zzn:
		tool.set_voxel(pos, _get_shape("narrow", 0))
	elif pzz and nzz:
		tool.set_voxel(pos, _get_shape("narrow", 16))
	elif zzp:
		tool.set_voxel(pos, _get_shape("end", 0))
	elif zzn:
		tool.set_voxel(pos, _get_shape("end", 10))
	elif pzz:
		tool.set_voxel(pos, _get_shape("end", 16))
	elif nzz:
		tool.set_voxel(pos, _get_shape("end", 22))
	else:
		tool.set_voxel(pos, _get_shape("spire", 0))

func bottom_shape(pos : Vector3i, mask : int):
	var zzp : bool = mask & ZZP > 0
	var pzz : bool = mask & PZZ > 0
	var zzn : bool = mask & ZZN > 0
	var nzz : bool = mask & NZZ > 0
	var pzp : bool = mask & PZP > 0
	var pzn : bool = mask & PZN > 0
	var nzp : bool = mask & NZP > 0
	var nzn : bool = mask & NZN > 0

	if zzn and nzz and nzn:
		tool.set_voxel(pos, _get_shape("corner", 2))
	elif zzp and pzz and pzp:
		tool.set_voxel(pos, _get_shape("corner", 8))
	elif zzp and nzz and nzp:
		tool.set_voxel(pos, _get_shape("corner", 18))
	elif zzn and pzz and pzn:
		tool.set_voxel(pos, _get_shape("corner", 20))
	elif zzp and nzz:
		tool.set_voxel(pos, _get_shape("lfork", 2))
	elif zzp and pzz:
		tool.set_voxel(pos, _get_shape("lfork", 8))
	elif zzn and nzz:
		tool.set_voxel(pos, _get_shape("lfork", 18))
	elif pzz and zzn:
		tool.set_voxel(pos, _get_shape("lfork", 20))
	elif zzp and zzn:
		tool.set_voxel(pos, _get_shape("narrow", 2))
	elif pzz and nzz:
		tool.set_voxel(pos, _get_shape("narrow", 18))
	elif zzn:
		tool.set_voxel(pos, _get_shape("end", 2))
	elif zzp:
		tool.set_voxel(pos, _get_shape("end", 8))
	elif nzz:
		tool.set_voxel(pos, _get_shape("end", 18))
	elif pzz:
		tool.set_voxel(pos, _get_shape("end", 20))
	else:
		tool.set_voxel(pos, _get_shape("spire", 2))
