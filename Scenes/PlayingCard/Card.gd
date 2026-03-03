class_name Card extends Node2D

enum SuitColor {
	Red,
	Black
}

@export var is_draggable = false
@export var suit = "H":
	set(new_value):
		suit = new_value
		if suit == "H" or suit == "D":
			color = SuitColor.Red
			$cardFace/Suit.add_theme_color_override("font_color", Color.RED)
			$cardFace/Rank.add_theme_color_override("font_color", Color.RED)
			$cardFace/Rank2.add_theme_color_override("font_color", Color.RED)
		else:
			color = SuitColor.Black
		$cardFace/Suit.text = suit
		
@export var rank = 1:
	set(new_value):
		rank = new_value
		$cardFace/Rank.text = process_rank()
		$cardFace/Rank2.text = process_rank()
@export var color: SuitColor
@export var isFaceUp = false:
	set(new_value):
		isFaceUp = new_value
		if isFaceUp:
			$cardBack.visible = false
			$cardFace.visible = true
		else:
			$cardBack.visible = true
			$cardFace.visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func process_rank():
	if rank == 11:
		return "J"
	elif rank == 12:
		return "Q"
	elif rank == 13:
		return "K"
	elif rank == 1:
		return "A"
	else:
		return str(rank)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
