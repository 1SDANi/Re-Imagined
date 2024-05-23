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

func _ready() -> void:
	game.set_slope_mesh(get_path())
	tool = get_voxel_tool()

func place(pos : Vector3i) -> void:
	tool.channel = VoxelBuffer.CHANNEL_TYPE
	var voxel : int = tool.get_voxel(pos)

	if voxel <= 0:
		tool.set_voxel(pos, 1)
		shapes(pos)
	else:
		tool.set_voxel(pos, 0)
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
		var pzp : bool = mask & PZP > 0
		var pzn : bool = mask & PZN > 0
		var nzp : bool = mask & NZP > 0
		var nzn : bool = mask & NZN > 0

		if zzp and pzz and zzn and nzz:
			tool.set_voxel(pos, 1)
		elif zzp and pzz and zzn:
			tool.set_voxel(pos, 13)
		elif zzp and pzz and nzz:
			tool.set_voxel(pos, 16)
		elif pzz and zzn and nzz:
			tool.set_voxel(pos, 14)
		elif zzp and zzn and nzz:
			tool.set_voxel(pos, 15)
		elif zzp and pzz:
			tool.set_voxel(pos, 8)
		elif zzp and nzz:
			tool.set_voxel(pos, 7)
		elif pzz and zzn:
			tool.set_voxel(pos, 9)
		elif zzn and nzz:
			tool.set_voxel(pos, 10)
		elif pzz and nzz:
			tool.set_voxel(pos, 12)
		elif zzp and zzn:
			tool.set_voxel(pos, 11)
		elif zzp:
			tool.set_voxel(pos, 3)
		elif pzz:
			tool.set_voxel(pos, 4)
		elif zzn:
			tool.set_voxel(pos, 5)
		elif nzz:
			tool.set_voxel(pos, 6)
		elif znz:
			tool.set_voxel(pos, 2)
		else:
			tool.set_voxel(pos, 1)
