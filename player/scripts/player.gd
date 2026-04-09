class_name Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://dlipckkyx6nxe");

#region onready variables
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D;
@onready var collision_stand: CollisionShape2D = $CollisionStand;
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch;
@onready var one_way_platform_raycast: RayCast2D = $OneWayPlatformRaycast;
#endregion

#region export variables
@export var movement_speed: float;
#endregion

#region state machine variables
var states: Array[PlayerState];
var current_state: PlayerState : 
	get : return states.front();
var previous_state: PlayerState :
	get : return states[1];
#endregion

#region standard variables
var direction: Vector2 = Vector2.ZERO;
var gravity: float = 980;
var gravity_multiplier: float = 1.0;
#endregion

func _ready() -> void:
	# initialize states
	initialize_states();
	
	pass;

func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))
	
	pass;

func _process(_delta: float) -> void:
	update_direction();
	change_state(current_state.process(_delta));
	
	pass;

func _physics_process(_delta: float) -> void:
	velocity.y += gravity * gravity_multiplier * _delta;
	move_and_slide();
	change_state(current_state.physics_process(_delta));
	
	pass;

func initialize_states() -> void:
	states = [];
	
	for state in $States.get_children():
		if state is PlayerState:
				states.append(state);
				state.player = self;
				
	for state in states:
		state.init();
		
	change_state(current_state);
	current_state.enter();
	
	$Label.text = current_state.name.to_lower();
	
	pass;

func change_state(state: PlayerState) -> void:
	if state == null or state == current_state:
		return;
	
	if current_state:
		current_state.exit();
		
	states.push_front(state);

	state.enter();
	states.resize(3);
	$Label.text = current_state.name;

	pass;
	
func update_direction():
	var previous_direction: Vector2 = direction;
	
	var x_axis = Input.get_axis("left", "right");
	var y_axis = Input.get_axis("up", "down");
	
	direction = Vector2(x_axis, y_axis);
	
	if previous_direction.x != direction.x:
		if direction.x < 0:
			sprite.scale.x = -1;
		
		if direction.x > 0:
			sprite.scale.x = 1;
	
	pass;
	
func add_debug_indicator(color: Color = Color.RED) -> void:
	var debug_indicator: Node2D = DEBUG_JUMP_INDICATOR.instantiate();
	get_tree().root.add_child(debug_indicator);
	
	debug_indicator.global_position = global_position;
	debug_indicator.modulate = color;
	
	await get_tree().create_timer(3.0).timeout;
	debug_indicator.queue_free();
	
	pass;
