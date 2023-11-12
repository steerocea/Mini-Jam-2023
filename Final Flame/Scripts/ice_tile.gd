extends Node2D

const fade_time:float = 1.0
var fade_timer:float = 0.0
var melting:bool = false

var meltbox:Area2D
var sprite:Sprite2D
var ice_sound:AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	meltbox = $Meltbox
	meltbox.body_entered.connect(_on_meltbox_entered)
	sprite = $Sprite2D
	ice_sound = $IceSound
	pass # Replace with function body.

func _on_meltbox_entered(body):
	if(!melting):
		print("Beginning melt")
		melting = true
		ice_sound.play()
	if(body.is_in_group("player")):
		body.refresh_walljump()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(melting):
		fade_timer += delta
		sprite.modulate = Color(sprite.modulate,1-(fade_timer/fade_time))
	if(fade_timer > fade_time):
		queue_free()
	pass
