extends MarginContainer

var screen_size
@export var card_being_dragged: Card
@export var stacked_cards: Array[Card]
var dragged_card_starting_positon
var dragged_card_started_z_index

@onready var deck_location = $PlayScreenControl/PlayScreenVbox/ScoringDeckHbox/DeckPosition
@onready var deck = $PlayScreenControl/PlayScreenVbox/ScoringDeckHbox/DeckPosition/Deck
@onready var drawn_cards = $PlayScreenControl/PlayScreenVbox/ScoringDeckHbox/DrawnPositionPanel
@onready var main_play = $PlayScreenControl/PlayScreenVbox/MainPlayHbox

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.global_position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y))
		for i in range(stacked_cards.size()):
			stacked_cards[i].global_position.x = card_being_dragged.global_position.x
			stacked_cards[i].global_position.y = card_being_dragged.global_position.y + (20 * (i+1))

# Handle input events.
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		print("escape pressed, open menu")
		$"PlayScreenControl/Play Menu".pause_game()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Raycast check for card
			var result = raycast_check_for_card()
			print(result)
			if result:
				if result == deck_location:
					print("Deck Empty, need to shuffle deck")
					for card in drawn_cards.get_children():
						if card is Card:
							deck.cards.push_front(card)
							card.reparent(deck)
						else:
							print("Found non card child")
					drawn_cards.clear_cards()
					deck.restack_deck()
				elif result.get_parent() == deck:
						draw_from_deck()
				elif result is Card and result.is_draggable:
					card_being_dragged = result
					stacked_cards = card_being_dragged.get_parent().get_stacked_cards(card_being_dragged)
					if stacked_cards:
						pass
					dragged_card_started_z_index = card_being_dragged.z_index
					card_being_dragged.z_index = 100
					for i in range(stacked_cards.size()):
						stacked_cards[i].z_index = 100 + (i + 1)
					dragged_card_starting_positon = card_being_dragged.global_position
		
		else:
			if card_being_dragged:
				if ! move_card():
					card_being_dragged.global_position = dragged_card_starting_positon
					card_being_dragged.z_index = dragged_card_started_z_index
					for i in range(stacked_cards.size()):
						stacked_cards[i].position.x = card_being_dragged.position.x
						stacked_cards[i].position.y = card_being_dragged.position.y + (20 * (i + 1))
						stacked_cards[i].z_index = dragged_card_started_z_index + i + 1
					
				stacked_cards = []
				card_being_dragged = null

func move_card() -> bool:
	var area2d:Area2D = card_being_dragged.get_child(2)
	var bodies = area2d.get_overlapping_areas()
	for body in bodies:
		var body_parent = body.get_parent()
		if body_parent is Card:
			body_parent = body_parent.get_parent()
		if body_parent is CardPosition:			
			var was_added = body_parent.add_dragged_card(card_being_dragged, stacked_cards)
			if was_added:
				return true
			
	return false

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var results = space_state.intersect_point(parameters)
	
	if results:
		var top_z_index = -1
		var return_node = null
		var clicked_deck = false
		
		for node in results:
			var node_parent = node.collider.get_parent()
			if node_parent == deck_location:
				clicked_deck = true
			# if not visible, can't click on it.
			if node_parent.visible and node_parent.z_index > top_z_index:
				top_z_index = node_parent.z_index
				return_node = node_parent
		
		if return_node == null and clicked_deck:
			print("clicked deck?")
			return_node = deck_location
		return return_node

func draw_from_deck():
	print("drawing from deck")
	for i in range(3):
		if ! deck.cards.is_empty():
			var drawn_card = deck.draw_card()
			drawn_card.isFaceUp = true
			drawn_card.is_draggable = true
			drawn_card.z_index = i
			drawn_cards.add_card(drawn_card)
		else:
			print("drew deck")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size	
	
	deck.shuffle()
	
	#deal out playfield
	for i in range(7):
		for j in range(i, 7):
			var drawn_card = deck.cards.pop_back()
			drawn_card.z_index = i
			if j == i:
				drawn_card.isFaceUp = true
				drawn_card.is_draggable = true
			# index is plus one as there is an empty panel for padding
			main_play.get_child(j+1).add_card(drawn_card)
