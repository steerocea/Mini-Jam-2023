extends Node2D

#Does a lot of tilemap substitution stuff
#Different sorts of tiles should be on different layers: All ice tiles on one layer, for example.


@export var tilemap:TileMap
var ice_scene = preload("res://Scenes/ice_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	do_cell_substitutions()
	pass # Replace with function body.

func do_cell_substitutions():
	var map_layer_count = tilemap.get_layers_count()
	for i in range(map_layer_count):
		if tilemap.get_layer_name(i) == "ice" :
			replace_ice_tiles(i)

func replace_ice_tiles(ice_layer_index:int):
	var ice_tiles:Array[Vector2i] = tilemap.get_used_cells(ice_layer_index)
	
	for ice_coord in ice_tiles:
		var new_ice = ice_scene.instantiate()
		new_ice.position = tilemap.map_to_local(ice_coord)
		tilemap.add_child(new_ice)
		pass
	tilemap.set_layer_enabled(ice_layer_index,false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
