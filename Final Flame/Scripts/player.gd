extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 700

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
var animation_player: AnimationPlayer = null
var character_sprite: Sprite2D = null

func _ready():
	animation_player = $AnimationPlayer  # Adjust the path based on the actual node hierarchy
	if animation_player == null:
		print("Error: AnimationPlayer not found.")
		return
		
	character_sprite = $Sprite2D  # Adjust the path based on the actual node hierarchy
	if character_sprite == null:
		print("Error: Sprite not found.")
		return

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
		if (Input.get_action_strength("walk_right") > 0):
			speed = 200
			horizontal_direction = 1
			character_sprite.scale.x = 1
			character_sprite.position.x = 15
		elif (Input.get_action_strength("walk_left") > 0):
			speed = 200
			horizontal_direction = -1
			character_sprite.scale.x = -1
			character_sprite.position.x = -15
		
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
			animation_player.play("Idle")
		PlayerState.WALKRIGHT:
			character_sprite.scale.x = 1
			character_sprite.position.x = 15
			animation_player.play("Walk-Right")
		PlayerState.WALKLEFT:
			character_sprite.scale.x = -1
			character_sprite.position.x = -15
			animation_player.play("Walk-Right")
		PlayerState.RUNRIGHT:
			character_sprite.scale.x = 1
			character_sprite.position.x = 15
			animation_player.play("Run-Right")
		PlayerState.RUNLEFT:
			character_sprite.scale.x = -1
			character_sprite.position.x = -15
			animation_player.play("Run-Right")
		PlayerState.JUMP:
			animation_player.play("Jump")
