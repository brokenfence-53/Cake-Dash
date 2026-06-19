extends Control
class_name LevelSelectMenu

@onready var pages : Node = $Pages
@onready var prev_button : Button = $NavButtons/PrevButton
@onready var next_button : Button = $NavButtons/NextButton
@onready var page_label : Label = $CanvasLayer/PageLabel
@onready var page_flip_overlay : Panel = $PageFlipOverlay
@onready var anim : AnimationPlayer = $AnimationPlayer

var current_page : int = 0

func _ready() -> void:
	_connect_all_cards()
	_show_page(0)

func _connect_all_cards() -> void:
	for page in pages.get_children():
		for card in page.get_children():
			if card is PhotoCard:
				if not card.level_selected.is_connected(_on_level_selected):
					card.level_selected.connect(_on_level_selected)

func _show_page(index: int) -> void:
	var page_nodes := pages.get_children()
	for i in page_nodes.size():
		page_nodes[i].visible = (i == index)
	current_page = index
	prev_button.disabled = current_page == 0
	next_button.disabled = current_page >= page_nodes.size() - 1
	page_label.text = "Page %d / %d" % [current_page + 1, page_nodes.size()]

func _on_prev_pressed() -> void:
	if current_page > 0:
		_play_back_then_show(current_page - 1)

func _on_next_pressed() -> void:
	if current_page < pages.get_child_count() - 1:
		_play_flip_then_show(current_page + 1)

func _play_flip_then_show(target_page: int) -> void:
	_hide_all_pages()
	anim.play("page_flip")
	await anim.animation_finished
	_show_page(target_page)

func _play_back_then_show(target_page: int) -> void:
	_hide_all_pages()
	anim.play("page_back")
	await anim.animation_finished
	_show_page(target_page)

func _hide_all_pages() -> void:
	for page in pages.get_children():
		page.visible = false

func _on_level_selected(level: LevelData) -> void:
	var card := _find_card_for_level(level)
	if card and card.level_scene:
		# get_tree().change_scene_to_packed(card.level_scene)
		TransitionManager.change_scene(card.level_scene)

func _find_card_for_level(level: LevelData) -> PhotoCard:
	for page in pages.get_children():
		for card in page.get_children():
			if card is PhotoCard and card.level_data == level:
				return card
	return null
