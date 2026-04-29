class_name CrouchState extends PlayerState

@export var deceleration_rate: float;

# what happens when this state is initialized?
func init() -> void:
	pass;
	
# what happens when we enter this state?
func enter() -> void:
	player.collision_stand.disabled = true;
	player.collision_crouch.disabled = false;
	
	player.sprite.animation = "crouch";
	
	pass;

# what happens when we exit this state?
func exit() -> void:
	player.collision_stand.disabled = false;
	player.collision_crouch.disabled = true;
	
	pass;

# what happens when an input is recieved?
func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		if player.one_way_platform_raycast.is_colliding() == true:
			player.position.y += 4;
			return fall;
		else:
			return jump;
		
	return next_state;

# what happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	if player.direction.y < 0.5:
		return idle;
		
	return next_state;

# what happens each physics process in this state?
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x -= player.velocity.x * deceleration_rate * _delta;
	
	if player.is_on_floor() == false:
		return fall;
	
	return next_state;
