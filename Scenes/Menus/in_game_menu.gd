class_name PauseMenu extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	$MainMenu.pressed.connect(_on_main_menu_pressed)
	$NewGame.pressed.connect(_on_new_game_pressed)
	$Resume.pressed.connect(resume_game)
	
func _on_new_game_pressed():
	resume_game()
	get_tree().reload_current_scene()
	
func _on_main_menu_pressed():
	resume_game()
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_menu()
			
		get_viewport().set_input_as_handled()
		
func toggle_menu():
	if get_tree().paused:
		resume_game()
	else:
		pause_game()

func pause_game():
	get_tree().paused = true
	show()
	
func resume_game():
	hide()
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
