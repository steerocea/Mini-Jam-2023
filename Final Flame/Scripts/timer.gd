extends Label

var time = 0
var timer_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(timer_on):
		time += delta
		
	var mils = fmod(time,1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60) / 60
	var hr = fmod(fmod(time,3600 * 60) / 3600,24)
	
	var time_passed = "%02d : %02d : %02d : %03d" % [hr,mins,secs,mils]
	text = time_passed
	
func time_stop():
	timer_on = false

func time_reset():
	time = 0
	
func time_start():
	timer_on = true
	
func center_timer():
	var viewport_size = get_viewport().size
	
	position.x = viewport_size.x/2 - 140
	position.y = viewport_size.y/2 
	
	
# Function to set the visibility of the timer
func set_timer_visibility(is_visible):
	visible = is_visible


# Function to follow the player's camera
#func follow_camera(camera_transform):
#	var offset = Vector2(300, -500)  # Adjust this offset based on your preference
#	var viewport_size = get_viewport().size
#	
#	position.x = camera_transform.origin.x + offset.x 
#	position.y = camera_transform.origin.y + offset.y 
