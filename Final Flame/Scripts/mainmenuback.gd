extends Node2D

var speed1 = 10
var speed2 = 20
var speed3 = 40
var speed4 = 80

var layer1: Sprite2D
var layer2: Sprite2D
var layer3: Sprite2D
var layer4: Sprite2D

var layer_widths := []

func _ready():
	# Get references to the Sprite nodes
	layer1 = $ParallaxBackground/ParallaxLayer/Sprite2D
	layer2 = $ParallaxBackground/ParallaxLayer2/Sprite2D
	layer3 = $ParallaxBackground/ParallaxLayer3/Sprite2D
	layer4 = $ParallaxBackground/ParallaxLayer4/Sprite2D

	# Set the initial positions of the layers
	layer1.position.x = 0
	layer2.position.x = layer1.position.x + layer1.texture.get_size().x
	layer3.position.x = layer2.position.x + layer2.texture.get_size().x
	layer4.position.x = layer3.position.x + layer3.texture.get_size().x

	# Store the widths of the layers
	layer_widths = [
		layer1.texture.get_size().x,
		layer2.texture.get_size().x,
		layer3.texture.get_size().x,
		layer4.texture.get_size().x
	]

func _process(delta):
	# Move the layers based on their respective speeds
	layer1.position.x += speed1 * delta
	layer2.position.x += speed2 * delta
	layer3.position.x += speed3 * delta
	layer4.position.x += speed4 * delta

	# Check if a layer has moved off-screen and smoothly adjust its position
	smooth_adjust_layer_position(layer1, layer_widths[0], speed1, delta)
	smooth_adjust_layer_position(layer2, layer_widths[1], speed2, delta)
	smooth_adjust_layer_position(layer3, layer_widths[2], speed3, delta)
	smooth_adjust_layer_position(layer4, layer_widths[3], speed4, delta)

func smooth_adjust_layer_position(layer: Sprite2D, width: float, speed: float, delta: float):
	# Smoothly adjust the layer's position if it has moved off-screen
	if layer.position.x > 0:
		layer.position.x = lerp(layer.position.x, -width, delta * speed)
	elif layer.position.x < -width:
		layer.position.x = lerp(layer.position.x, -width, delta * speed)
