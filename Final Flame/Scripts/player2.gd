extends CharacterBody2D

#TODO: Jump Buffer
#TODO: Coyote Timer
#TODO: Integrate animations

@export var speed = 400
@export var gravity = 30
@export var jump_force = 700
@export var wall_jump_force = 150

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
	
	run()
	#jump does gravity and jumps/walljumps for us: basically handles verticality.
	jump()
	
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

var input_direction = 0

func run():
	input_direction = 0
	if Input.is_action_pressed("walk_left"):
		input_direction -= 1
	if Input.is_action_pressed("walk_right"):
		input_direction += 1
	
	velocity.x = input_direction*speed

const coyote_timer:float = 0.3
var general_coyote_time:float = 0
var walljump_coyote_time:float = 0
var has_jump:bool = true
var has_walljump:bool = true

func jump():
	#If we're in contact with a wall or floor, refresh jump timers.
	if is_on_floor():
		general_coyote_time = 0
		#only refresh whether we have a jump on touching the ground though.
		has_jump = true
		has_walljump = true
	if is_on_wall() and input_direction != 0:
		walljump_coyote_time = 0
	if Input.is_action_just_pressed("jump"):
		if general_coyote_time < coyote_timer and has_jump:
			velocity.y = -jump_force
			has_jump = false
		if walljump_coyote_time < coyote_timer and has_walljump:
			velocity.y = -jump_force
			velocity.x = -input_direction*speed
			has_walljump = false
	
	else:
		velocity.y += gravity

func _process(delta):
	update_timers(delta)

func update_timers(delta):
	general_coyote_time += delta
	walljump_coyote_time += delta

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



