extends Node2D

@export var pipe_scene: PackedScene
@export var finish_scene: PackedScene

const SCROLL_SPEED: float = 125.0
const PIPE_DELAY: int = 150
const PIPE_RANGE: int = 150
const WORD: String = "HARIG"

var game_running: bool
var game_over: bool
var scroll: float = 0.0
var score
var ground_height: int
var pipes: Array
var pipe_count: int = 0
var letter_index: int = 0
var screen_size: Vector2i

func _ready() -> void:
	add_to_group("MainGame")
	screen_size = get_window().size
	ground_height = $Ground/Area2D/Sprite2D.texture.get_height()
	new_game()
	
func new_game() -> void:
	game_running = false
	game_over = false
	score = 0
	scroll = 0.0
	pipe_count = 0
	letter_index = 0
	
	for pipe in pipes:
		if is_instance_valid(pipe):
			pipe.queue_free()
			
	pipes.clear()
	$Bird.reset()
	$Won.visible = false
	$Again.visible = false
	
func _input(event: InputEvent) -> void:
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				elif $Bird.flying:
					$Bird.flap()
					
func start_game() -> void:
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$PipeTimer.start()
	generate_pipes()
	
func _process(delta: float) -> void:
	if game_running:
		check_top()
		
		scroll += SCROLL_SPEED * delta
		if scroll >= 288:
			scroll = 0
		$Ground/Area2D.position.x = -scroll
		
		for pipe in pipes:
			if is_instance_valid(pipe):
				pipe.position.x -= SCROLL_SPEED * delta

func _on_pipe_timer_timeout() -> void:
	generate_pipes()
	
func generate_pipes() -> void:
	if letter_index >= WORD.length():
		spawn_finish()
		return
	
	var pipe = pipe_scene.instantiate()
	pipe.position.x = 288 + PIPE_DELAY
	pipe.position.y = (512 - ground_height) / 2.0 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	if pipe_count % 2 == 0 and letter_index < WORD.length():
		var next_letter = WORD[letter_index]
		if pipe.get_node("Area2D").has_method("set_letter"):
			pipe.get_node("Area2D").set_letter(next_letter)
		letter_index += 1
	elif pipe.get_node("Area2D").has_method("hide_letter"):
		pipe.get_node("Area2D").hide_letter()
			
	add_child(pipe)
	pipes.append(pipe)
	pipe_count += 1

func spawn_finish() -> void:
	var finish = finish_scene.instantiate()
	finish.position.x = 288 + PIPE_DELAY
	finish.position.y = (512 - ground_height) / 2.0
	
	if finish.has_node("Area2D"):
		finish.get_node("Area2D").body_entered.connect(_on_finish_entered)
	
	add_child(finish)
	pipes.append(finish)
	
func _on_finish_entered(body) -> void:
	if body.name == "Bird":
		$Won.visible = true
		stop_game()
	
func stop_game() -> void:
	$PipeTimer.stop()
	$Bird.flying = false
	game_running = false
	game_over = true

func check_top() -> void:
	if $Bird.position.y < 0:
		$Bird.flying = false
		$Bird.falling = true
		stop_game()
			
func bird_hit() -> void:
	if $Bird.falling or game_over:
		return
		
	game_over = true
	$Bird.flying = false
	$Bird.falling = true
	stop_game()


func _on_ground_hit() -> void:
	$Bird.flying = false
	$Bird.falling = false
	$Again.visible = true

func _on_again_button_pressed() -> void:
	new_game()
