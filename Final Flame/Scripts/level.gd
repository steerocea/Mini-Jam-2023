extends Node2D

#Does a lot of tilemap substitution stuff
#Different sorts of tiles should be on different layers: All ice tiles on one layer, for example.


@export var tilemap:TileMap
@export var death_zone:Area2D
@export var win_zone:Area2D
@export var camera:Camera2D
var ice_scene:PackedScene = preload("res://Scenes/ice_tile.tscn")
var tile_size:Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(tilemap,"No Tilemap assigned")
	assert(death_zone,"No Death Zone Area2D assigned")
	assert(win_zone,"No Win Zone Area2D assigned")
	assert(camera,"No Camera assigned")
	tile_size = tilemap.tile_set.tile_size
	do_cell_substitutions()
	set_boundaries()
	pass # Replace with function body.

func do_cell_substitutions():
	var map_layer_count = tilemap.get_layers_count()
	for i in range(map_layer_count):
		if tilemap.get_layer_name(i) == "ice" :
			replace_ice_tiles(i)
		if tilemap.get_layer_name(i) == "death" :
			add_death_collisions(i)
		if tilemap.get_layer_name(i) == "win" :
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

func add_win_collisions(win_layer_index:int):
	var win_tiles:Array[Vector2i] = tilemap.get_used_cells(win_layer_index)
	for win_coord in win_tiles:
		var new_win_node = CollisionShape2D.new()
		new_win_node.position = tilemap.map_to_local(win_coord)
		var new_win_shape = RectangleShape2D.new()
		new_win_shape.size = tile_size
		new_win_node.shape = new_win_shape
		tilemap.add_child(new_win_node)
		pass
	tilemap.set_layer_enabled(win_layer_index,false)

func set_boundaries():
	var map_limits = tilemap.get_used_rect()
	var map_cellsize = tilemap.tile_set.tile_size
	
	var left = map_limits.position.x * map_cellsize.x
	var right = map_limits.end.x * map_cellsize.x
	var top = map_limits.position.y * map_cellsize.y
	var bottom = map_limits.end.y * map_cellsize.y
	
	camera.limit_left = left
	camera.limit_right = right
	camera.limit_top = top
	camera.limit_bottom = bottom
	
	var barrier_node = StaticBody2D.new()
	
	var left_segment = SegmentShape2D.new()
	left_segment.a = Vector2(left,top)
	left_segment.b = Vector2(left,bottom)
	
	var barrier_shape_left = CollisionShape2D.new()
	barrier_shape_left.shape = left_segment
	
	barrier_node.add_child(barrier_shape_left)
	
	var right_segment = SegmentShape2D.new()
	right_segment.a = Vector2(right,top)
	right_segment.b = Vector2(right,bottom)
	
	var barrier_shape_right = CollisionShape2D.new()
	barrier_shape_right.shape = right_segment
	
	barrier_node.add_child(barrier_shape_right)
	
	self.add_child(barrier_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
