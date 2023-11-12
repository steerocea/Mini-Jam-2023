extends CharacterBody2D

var left_pressed:bool = false
var right_pressed:bool = false
var up_pressed:bool = false
var down_pressed:bool = false

var inputDir:Vector2 = Vector2.ZERO

@export var speed = 300
@export var gravity = 30
@export var jump_force = 500
@export var wall_jump_force = 150
@export var friction = 15


var footstep_sound : AudioStreamPlayer = null
var jump_sound : AudioStreamPlayer = null
var player_is_dead = false
var footstep_playing = false

# | Negative = Left | 0 = Neutral | Positive = Right |
var horizontal_direction:int = 0
var sprinting:bool = false
var jumping:bool = false
var sliding:bool = false

func update_input_vars():
	horizontal_direction = 0
	if Input.is_action_pressed("run_left"):
		horizontal_direction -= 1
	if Input.is_action_pressed("run_right"):
		horizontal_direction += 1
	
	sprinting = Input.is_action_pressed("sprint")
	
	jumping = Input.is_action_pressed("jump")
	
	sliding = Input.is_action_pressed("slide")

enum AnimState {
	IDLE,
	WALK,
	RUN,
	JUMP,
	FALL,
	SLIDE,
	DEATH,
	WALLHANG,
	WALLJUMP,
}

var facing_right = true

var state: AnimState = AnimState.IDLE
var animation_player: AnimationPlayer = null
var character_sprite: Sprite2D = null

func update_animation():
	pass

func _process(_delta):
	#Three cases: Midair, On the ground, and on a wall.
	#Ground beats wall beats midair.
	update_animation()
	update_input_vars()

@export var base_speed = 200

func _physics_process(delta):
	if is_on_floor():
		handle_floor_input()
	elif is_on_wall():
		handle_wall_input()
	else:
		handle_midair_input()

func handle_floor_input():
	#If we're on the floor, our X velocity is subject to friction.
	if(horizontal_direction == 0):
		velocity.x = move_toward(velocity.x, 0, speed)
	elif(horizontal_direction > 0):
		#right
		velocity.x = speed;
	else:
		#left
		velocity.x = -speed;

func handle_wall_input():
	pass

func handle_midair_input():
	pass

func stash():
	if is_on_floor():
		if(horizontal_direction == 0):
			velocity.x = move_toward(velocity.x, 0, speed)
			state = PlayerState.IDLE
		elif(horizontal_direction > 0):
			#right
			velocity.x = speed;
			state = PlayerState.RUNRIGHT
		else:
			#left
			velocity.x = -speed;
			state = PlayerState.RUNLEFT
		if jumping:
			velocity.y = -jump_force
			state = PlayerState.JUMP
			jump_sound.play()
		elif sliding:
			state = PlayerState.SLIDE
		pass
	elif is_on_wall():
		state = PlayerState.WALLHANG
		velocity.y = min(velocity.y, 0)  # Stop upward movement on the wall
		velocity.y += friction # Slide downwars
	else:
		velocity.y += gravity
