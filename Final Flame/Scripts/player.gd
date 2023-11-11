extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 1000

enum PlayerState {
	IDLE,
	WALKRIGHT,
	WALKLEFT,
	RUNRIGHT,
	RUNLEFT,
	JUMP,
}

var state: PlayerState = PlayerState.IDLE
var horizontal_direction = 0

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
		
	elif Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_force
			state = PlayerState.JUMP
	elif ((Input.get_action_strength("walk_left") > 0) && (Input.get_action_strength("run_left") == 0)):
		if Input.get_action_strength("sprint") > 0:
			speed = 400
			state = PlayerState.RUNLEFT
		else:
			speed = 200
			state = PlayerState.WALKLEFT
		horizontal_direction = -1
	elif ((Input.get_action_strength("walk_right") > 0) && (Input.get_action_strength("run_right") == 0)):
		if Input.get_action_strength("sprint") > 0:
			speed = 400
			state = PlayerState.RUNRIGHT
		else:
			speed = 200
			state = PlayerState.WALKRIGHT
		horizontal_direction = 1
	elif Input.get_action_strength("run_left") > 0:
		speed = 400
		horizontal_direction = -1
		state = PlayerState.RUNLEFT
	elif Input.get_action_strength("run_right") > 0:
		speed = 400
		horizontal_direction = 1
		state = PlayerState.RUNRIGHT
	else:
		speed = 0
		horizontal_direction = 0
		state = PlayerState.IDLE
		
	velocity.x = speed * horizontal_direction
	move_and_slide()
	
	match state:
		PlayerState.IDLE:
			pass
		PlayerState.WALKRIGHT:
			pass
		PlayerState.WALKLEFT:
			pass
		PlayerState.RUNRIGHT:
			pass
		PlayerState.RUNLEFT:
			pass
		PlayerState.JUMP:
			pass
