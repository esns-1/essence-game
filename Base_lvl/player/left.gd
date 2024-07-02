extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const GRAVITY = 1000
@export var speed : int = 300
@export var jump : int = -300
@export var jump_horazontal : int = 100

enum state { idle, run, jump }

var current_state : state

var character_sprite : Sprite2D

func _ready():
	current_state = state.idle


func _physics_process(delta : float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	
	player_animations()
	
	print("State: ", state.keys()[current_state])


func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta


func player_idle(delta : float):
	if is_on_floor():
		current_state = state.idle


func player_run(delta : float):
	var direction = input_movement()
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if direction != 0:
		current_state = state.run
	
		animated_sprite_2d.flip_h = false if direction > 0 else true


func player_jump(delta : float):
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump
		current_state = state.jump
	
	
	
	if !is_on_floor() and current_state == state.jump:
		var direction = input_movement()
		velocity.x += direction * jump_horazontal * delta


func player_animations():
	if current_state == state.idle:
		animated_sprite_2d.play("idle_right")
	elif current_state == state.run:
		animated_sprite_2d.play("walk_right_1")
	elif current_state == state.jump:
		animated_sprite_2d.play("jump")

func input_movement():
	var direction : float = Input.get_axis ("move left", "move right")
	
	return direction
