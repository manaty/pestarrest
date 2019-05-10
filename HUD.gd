extends CanvasLayer

signal start_game

onready var player_score_counter = $"../GUI/HBoxContainer/Counters/Counter/Background/EnemyCounter"
onready var player_life_gauge = $"../GUI/HBoxContainer/Bars/Bar/Gauge"
onready var player_life_counter = $"../GUI/HBoxContainer/Bars/Bar/Count/Background/Number"

func update_score(score):
	player_score_counter.text = str(score)

func update_life(life):
	player_life_gauge.value = life
	player_life_counter.text = str(life)    

func show_message(text):
    $MessageLabel.text = text
    $MessageLabel.show()
    $MessageTimer.start()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Kill the pests!"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), 'timeout')
	$StartButton.show()
	
	
func show_level_passed():
	show_message("Level passed!!!")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "New pests coming!"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), 'timeout')
	$StartButton.show()

func _on_Button_pressed():
	$StartButton.hide()
	$MessageLabel.hide()
	emit_signal("start_game")
