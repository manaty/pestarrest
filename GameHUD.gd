extends CanvasLayer

signal retry

onready var player_life_counter = get_node("GUI/HBoxContainer/Bars/Bar/Count/Background/Number")
onready var player_score_counter = get_node("GUI/HBoxContainer/Counters/Counter/Background/EnemyCounter")
onready var player_life_gauge = get_node("GUI/HBoxContainer/Bars/Bar/Gauge")
onready var game_msg_label = get_node("MessageMarginContainer/HBoxContainer/GameMsgLabel")

func game_start_message(msg):	
	update_game_msg_label(msg)
	$MessageMarginContainer.show()
	game_msg_label.show()
	
func show_level_won():
	update_game_msg_label("Level cleared")
	$MessageMarginContainer.show()
	game_msg_label.show()
	$ButtonMarginContainer.show()	

func show_game_over():
	update_game_msg_label("Game over")
	$MessageMarginContainer.show()
	game_msg_label.show()
	$ButtonMarginContainer.show()
	
func hide_game_over():
	$MessageMarginContainer.hide()
	$ButtonMarginContainer.hide()
	hide_msg_label()

func hide_msg_label():
	game_msg_label.hide()

func show_game_msg_label():
	game_msg_label.show()
	
func update_game_msg_label(text):
	game_msg_label.text = text
	
func update_life(life):
	player_life_gauge.value = life
	if life < 0:
		life  = 0
	player_life_counter.text = str(life)    
	
func update_score(score):
	player_score_counter.text = str(score)	

func _on_QuitButton_pressed():
	get_tree().change_scene("res://title_screen/TitleScreen.tscn")

func _on_RetryButton_pressed():
	emit_signal("retry")
