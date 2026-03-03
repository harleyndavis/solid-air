extends Node2D

const card_scene = preload("res://Scenes/PlayingCard/Card.tscn")


const suits = ["S", "H", "D", "C"]
const ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1]
@export var cards: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Deck _ready")
	var location = 0
	for suit in suits:
		for rank in ranks:
			var new_card = card_scene.instantiate()
			new_card.suit = suit
			new_card.rank = rank
			new_card.name = create_card_name(suit, rank)
			new_card.isFaceUp = false
			cards.append(new_card)
			new_card.position = Vector2(-location/2.0, -location/2.0)
			add_child(new_card, true)
			location += 1
			
func create_card_name(suit, rank):
	var name: String = ""
	match rank:
		"11": name += "Jack "
		"12": name += "Queen "
		"13": name += "King "
		"1": name += "Ace "
		_: name += str(rank) + " "
	name += "of "
	
	match suit:
		"D": name += "Diamonds"
		"C": name += "Clubs"
		"H": name += "Hearts"
		"S": name += "Spades"
	
	return name

func draw_card() -> Node2D:
	if ! cards.is_empty():
		return cards.pop_back()
	else:
		return null
			
func shuffle():
	# Shuffle deck and set z_index
	cards.shuffle()
	restack_deck()
	
func restack_deck():	
	for i in range(cards.size()):
		cards[i].isFaceUp = false
		cards[i].visible = true
		cards[i].position = Vector2(-i/2, -i/2)
		cards[i].z_index = i


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
