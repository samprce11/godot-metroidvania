class_name LedgeGrabState extends PlayerState

var entered_scale: float;

# what happens when this state is initialized?
func init() -> void:
	pass;

# what happens when we enter this state?
func enter() -> void:
	player.sprite.play("ledge_grab");
	entered_scale = player.sprite.scale.x;
	pass;

func exit() -> void:
	if player.direction.x < 0:
		player.sprite.scale.x = -1;
	
	if player.direction.x > 0:
		player.sprite.scale.x = 1;
	pass;

func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump;

	return next_state;	
	
func process(_delta: float) -> PlayerState:
	player.sprite.scale.x = entered_scale;
	
	if player.ledge_grab.disabled:
		return idle;
		
	return next_state;
	
func physics_process(_delta: float) -> PlayerState:
	return next_state;
