extends Node2D

#Does a lot of tilemap substitution stuff
#Different sorts of tiles should be on different layers: All ice tiles on one layer, for example.


@export var tilemap:TileMap
@export var death_zone:Area2D
var ice_scene:PackedScene = preload("res://Scenes/ice_tile.tscn")
var tile_size:Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_size = tilemap.tile_set.tile_size
	do_cell_substitutions()
	pass # Replace with function body.

func do_cell_substitutions():
	var map_layer_count = tilemap.get_layers_count()
	for i in range(map_layer_count):
		if tilemap.get_layer_name(i) == "ice" :
			replace_ice_tiles(i)
		if tilemap.get_layer_name(i) == "death" :
			add_death_collisions(i)

func replace_ice_tiles(ice_layer_index:int):
	var ice_tiles:Array[Vector2i] = tilemap.get_used_cells(ice_layer_index)
	for ice_coord in ice_tiles:
		var new_ice = ice_scene.instantiate()
		new_ice.position = tilemap.map_to_local(ice_coord)
		tilemap.add_child(new_ice)
		pass
	tilemap.set_layer_enabled(ice_layer_index,false)

func add_death_collisions(death_layer_index:int):
	var death_tiles:Array[Vector2i] = tilemap.get_used_cells(death_layer_index)
	for death_coord in death_tiles:
		var new_death_node = CollisionShape2D.new()
		new_death_node.position = tilemap.map_to_local(death_coord)
		var new_death_shape = RectangleShape2D.new()
		new_death_shape.size = tile_size
		new_death_node.shape = new_death_shape
		tilemap.add_child(new_death_node)
		pass
	tilemap.set_layer_enabled(death_layer_index,false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
