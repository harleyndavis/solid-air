extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_button_pressed)
	print(self.get_global_rect())
	self.mouse_entered.connect(_on_button_mouse_entered)
	self.mouse_exited.connect(_on_button_mouse_exited)

func _on_hover_entered():
	print("Hover signal fired!")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Solitaire.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_mouse_entered():
	print("mouse_entered()")
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.12)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 10, 0.1)

func _on_button_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.08)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 10, 0.1)


func _on_panel_mouse_entered() -> void:
	print("test mouse enter panel") # Replace with function body.
