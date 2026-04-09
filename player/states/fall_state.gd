class_name FallState extends PlayerState

@export var coyote_time: float;
@export var fall_gravity_multiplier: float;
@export var jump_buffer_time: float;

var coyote_timer: float;
var jump_buffer_timer: float;

# what happens when this state is initialized?
func init() -> void:
	pass;
	
# what happens when we enter this state?
func enter() -> void:
	player.sprite.animation = "fall";
	
	player.gravity_multiplier = fall_gravity_multiplier;
	
	if player.previous_state == jump:
		coyote_timer = 0;
	else:
		coyote_timer = coyote_time;
	
	pass;

# what happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1.0;
	jump_buffer_timer = 0;
	
	pass;

# what happens when an input is recieved?
func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		if coyote_timer > 0:
			return jump;
		else:
			jump_buffer_timer = jump_buffer_time;
		
	return next_state;

# what happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	coyote_timer -= _delta;
	jump_buffer_timer -= _delta;
	
	return next_state;

# what happens each physics process in this state?
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		player.add_debug_indicator(Color.RED);
		if jump_buffer_timer > 0:
			return jump;
		return idle;
		
	player.velocity.x = player.direction.x * player.movement_speed;
		
	return next_state;
