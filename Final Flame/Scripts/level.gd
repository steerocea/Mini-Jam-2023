extends Node2D

@export var tilemap:TileMap
var ice_scene = preload("res://Scenes/ice_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	replace_ice_tiles()
	pass # Replace with function body.

func replace_ice_tiles():
	var ice_tiles:Array[Vector2i] = []
	var tiles:Array[Vector2i] = tilemap.get_used_cells(0)
	for coordinate in tiles:
		var current_tile_data:TileData = tilemap.get_cell_tile_data(0,coordinate)
		var is_ice = current_tile_data.get_custom_data("meltable")
		if(is_ice):
			ice_tiles.append(coordinate)
		pass
	
	for ice_coord in ice_tiles:
		tilemap.erase_cell(0,ice_coord)
		var new_ice = ice_scene.instantiate()
		new_ice.position = tilemap.map_to_local(ice_coord)
		tilemap.add_child(new_ice)
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
