extends CanvasLayer

signal load_scene_started;
signal new_scene_ready(target_area: String, player_offset: Vector2);
signal load_scene_finished;

@onready var fade: Control = $Fade

func _ready() -> void:
	fade.visible = false;
	
	await get_tree().process_frame;
	load_scene_finished.emit();
	
	pass;

func transition_scene(new_scene: String, target_area: String, player_offset: Vector2, direction: String) -> void:
	get_tree().paused = true;
	
	var fade_position: Vector2 = get_fade_position(direction);
	fade.visible = true;
	
	load_scene_started.emit();
	
	await fade_screen(fade_position, Vector2.ZERO);
	
	get_tree().change_scene_to_file(new_scene);
	
	await get_tree().scene_changed;
	new_scene_ready.emit(target_area, player_offset);
	
	await fade_screen(Vector2.ZERO, -fade_position);
	
	fade.visible = false;
	get_tree().paused = false;
	
	load_scene_finished.emit();
	
	pass;
	
func fade_screen(from: Vector2, to: Vector2) -> Signal:
	fade.position = from;
	
	var tween: Tween = create_tween();
	tween.tween_property(fade, "position", to, 0.2);
	
	return tween.finished;

func get_fade_position(direction: String) -> Vector2:
	var postition: Vector2 = Vector2(480 * 2, 270 * 2);
	
	match direction:
		"left":
			postition *= Vector2(-1, 0);
		"right":
			postition *= Vector2(1, 0);
		"top":
			postition *= Vector2(0, -1);
		"bottom":
			postition *= Vector2(0, 1);
	
	return postition;
