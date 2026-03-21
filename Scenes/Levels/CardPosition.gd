class_name CardPosition extends MarginContainer


const card_offset_x = 60
const card_offset_y = 84

enum PositionType {
	Score,
	Play,
	Deck,
	Drawn
}

@export var position_type: PositionType
@export var cards: Array[Card] = []
var next_offset = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func clear_cards():
	cards = []
	
func get_stacked_cards(card) -> Array[Card]:
	var stacked_cards: Array[Card] = []
	var index = cards.find(card)
	if index < cards.size() - 1:
		for i in range(index + 1, cards.size()):
			stacked_cards.append(cards[i])
	return stacked_cards
	
func add_dragged_card(card:Card, stacked_cards:Array[Card] = []) -> bool:
	# Check if right suit and rank incremented +1
	var card_moved = false
	if position_type == PositionType.Score:
		card_moved = add_dragged_card_to_score(card)
	if position_type == PositionType.Play:
		if add_dragged_card_to_play(card):
			for stacked_card in stacked_cards:
				add_dragged_card(stacked_card)
			card_moved = true
			
	return card_moved

func update_drawn_position():
	print("updating drawn position")
	for i in range(cards.size()):
		if i == 3:
			return
		cards[i].position.x -= 30
		cards[i].visible = true
		if i == 0:
			cards[i].is_draggable = true

func add_dragged_card_to_play(card: Card) -> bool:
	if cards.is_empty() and card.rank == 13:
		card.get_parent().remove_top_card()
		add_card(card)
		return true
	elif not cards.is_empty() and cards[-1].color != card.color and \
		card.rank + 1 == cards[-1].rank:
		card.get_parent().remove_top_card()
		add_card(card)
		return true
	return false

func add_dragged_card_to_score(card:Card):
	if ((cards.is_empty() and card.rank == 1)
		or (! cards.is_empty() and cards[-1].rank == (card.rank - 1) and
		cards[-1].suit == card.suit)
	):
		card.get_parent().remove_top_card()
		add_card(card)
		return true
	return false

func remove_top_card():
	cards.pop_back()
	if not cards.is_empty():
		next_offset -= 30 if cards[-1].isFaceUp else 10
		cards[-1].isFaceUp = true
		cards[-1].is_draggable = true
	else: 
		next_offset = 0
		
	if position_type == PositionType.Drawn:
		if cards.size() > 0:
			cards[-1].is_draggable = true
		for i in range(min(3, cards.size())):
			cards[-1-i].visible = true
			cards[-1-i].position.x -= 30
			cards[-1-i].z_index += 1

func add_card(card: Card):
	print("adding card %s to %s" % [card, self])
	card.reparent(self)
	card.position.x = card_offset_x
	card.position.y = card_offset_y
	card.z_index = cards.size()
	if position_type == PositionType.Play:
		card.position.y += next_offset
		next_offset += 30 if card.isFaceUp else 10
	if position_type == PositionType.Drawn:
		add_drawn_card(card)
		
	cards.append(card)

func add_drawn_card(card):
	if (cards.size() >= 3):
		var size = cards.size()
		cards[size-3].visible = false
	if cards:
		for i in range(min(3, cards.size())):
			cards[-1-i].is_draggable = false
			cards[-1-i].z_index -= 1
			cards[-1-i].position.x += 30
	card.z_index = 3
	card.position.x = 70
	card.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
