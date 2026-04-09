class_name JumpState extends PlayerState

@export var jump_velocity: float;
@export var jump_movement_speed: float;

# what happens when this state is initialized?
func init() -> void:
	pass;
	
# what happens when we enter this state?
func enter() -> void:
	player.sprite.animation = "jump";
	
	player.add_debug_indicator(Color.PALE_GREEN);

	player.velocity.y = -jump_velocity;
	if player.previous_state == fall and not Input.is_action_pressed("jump"):
		# wait for the next physics frame and then run this logic
		await get_tree().physics_frame;
		player.velocity.y *= 0.5;
		player.change_state(fall);
		
	pass;

# what happens when we exit this state?
func exit() -> void:
	pass;

# what happens when an input is recieved?
func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_released("jump"):
		player.velocity.y *= 0.5;
		return fall;
	
	return next_state;

# what happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	return next_state;

# what happens each physics process in this state?
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle;
	
	if player.velocity.y >= 0:
		player.add_debug_indicator(Color.YELLOW);
		
		return fall;
		
	player.velocity.x = player.direction.x * player.movement_speed;
	
	return next_state;
