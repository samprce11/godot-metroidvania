class_name RunState extends PlayerState

# what happens when this state is initialized?
func init() -> void:
	pass;
	
# what happens when we enter this state?
func enter() -> void:
	player.ledge_grab.disabled = true;
	player.sprite.play("run");
	
	pass;

# what happens when we exit this state?
func exit() -> void:
	pass;

# what happens when an input is recieved?
func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump;
		
	return next_state;

# what happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	if player.direction.x == 0:
		return idle;
	elif player.direction.y > 0.5:
		return crouch;
		
	return next_state;

# what happens each physics process in this state?
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.movement_speed;
	
	if player.is_on_floor() == false:
		return fall;
	
	return next_state;
