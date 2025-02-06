class_name PaletteTile
extends Resource

@export var tile_tex_names : Array[String]
@export var map_tex_names : Array[String]

# while fill is true, fill all empty voxels with fill_palette
@export var fill_palette : VoxelPalette
@export var fill : bool

@export var slope_geo : TileGeo
@export var slope_tex : TileTex
@export var smooth_geo : TileGeo
@export var smooth_tex : TileTex
@export var model_vox : TileVox

@export var size : Vector3i
