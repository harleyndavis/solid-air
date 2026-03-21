extends Button

signal menu_pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		self.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	emit_signal("menu_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
