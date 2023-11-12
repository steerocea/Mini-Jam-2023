extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 700
@export var wall_jump_force = 150
@export var friction = 15

enum PlayerState {
	IDLE,
	WALKRIGHT,
	WALKLEFT,
	RUNRIGHT,
	RUNLEFT,
	JUMP,
	SLIDE,
	DEATH,
	WALLHANG,
	WALLJUMP,
}

var state: PlayerState = PlayerState.IDLE
var horizontal_direction = 0
var animation_player: AnimationPlayer = null
var character_sprite: Sprite2D = null
var footstep_sound : AudioStreamPlayer = null
var jump_sound : AudioStreamPlayer = null
var player_is_dead = false
var footstep_playing = false

func _ready():
	player_is_dead = false
	
	animation_player = $AnimationPlayer  # Adjust the path based on the actual node hierarchy
	if animation_player == null:
		print("Error: AnimationPlayer not found.")
		return
		
	character_sprite = $Sprite2D  # Adjust the path based on the actual node hierarchy
	if character_sprite == null:
		print("Error: Sprite not found.")
		return
		
	footstep_sound = $footstep
	jump_sound = $jump
	
	footstep_sound.connect("finished", _on_FootstepSound_finished)

func _physics_process(delta):
	if !is_on_floor():
		if is_on_wall():
			state = PlayerState.WALLHANG
			velocity.y = min(velocity.y, 0)  # Stop upward movement on the wall
			velocity.y += friction  # Apply a slow downward force
		else:
			velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
		if (Input.get_action_strength("walk_right") > 0) and !is_on_wall():
			if (Input.get_action_strength("sprint") > 0):
				speed = 400
			else:
				speed = 200
			horizontal_direction = 1
			character_sprite.scale.x = 1
			character_sprite.position.x = 15
		elif (Input.get_action_strength("walk_left") > 0) and !is_on_wall():
			if (Input.get_action_strength("sprint") > 0):
				speed = 400
			else:
				speed = 200
			horizontal_direction = -1
			character_sprite.scale.x = -1
			character_sprite.position.x = -15
		elif Input.is_action_just_pressed("jump"):
			if state == PlayerState.WALLHANG:
				velocity.y = -jump_force
				speed = 100
				horizontal_direction = horizontal_direction * -1
				state = PlayerState.WALLJUMP
				jump_sound.play()
	elif Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_force
			state = PlayerState.JUMP
			jump_sound.play()
	#place holder
	elif Input.is_action_just_pressed("death"):
		state = PlayerState.DEATH
	elif Input.get_action_strength("slide") > 0:
		if is_on_floor():
			speed = 500
			state = PlayerState.SLIDE
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
		if !player_is_dead:
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
			play_footstep_sound()
		PlayerState.RUNLEFT:
			character_sprite.scale.x = -1
			character_sprite.position.x = -15
			animation_player.play("Run-Right")
			play_footstep_sound()
		PlayerState.JUMP:
			animation_player.play("Jump")
		PlayerState.SLIDE:
			animation_player.play("Slide-Right")
		PlayerState.WALLHANG:
			animation_player.play("Wall-Hang")
		PlayerState.WALLJUMP:
			animation_player.play("Wall-Jump")
		PlayerState.DEATH:
			# Pause the game
			#get_tree().paused = true

			# Play the death animation
			animation_player.play("Death")
			
			player_is_dead = true
			
			#show_game_over_screen()

# Function to show the game over screen
func show_game_over_screen():
	# Load the game over scene
	var game_over_instance = load("res://Scenes/game-over.tscn")

	# Get the root node (CanvasLayer or Control) of the game over scene
	var game_over_root: Control = game_over_instance  # Adjust this if your root node has a different name or type

	# Add the game over root to the scene tree
	get_tree().get_root().add_child(game_over_root)
	
func play_footstep_sound():
	if !footstep_playing:
		footstep_sound.play()
		footstep_playing = true
		
func _on_FootstepSound_finished():
	footstep_playing = false



