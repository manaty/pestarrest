extends CanvasLayer


onready var player_life_counter = get_node("GUI/HBoxContainer/Bars/Bar/Count/Background/Number")
onready var player_score_counter = get_node("GUI/HBoxContainer/Counters/Counter/Background/EnemyCounter")
onready var player_life_gauge = get_node("GUI/HBoxContainer/Bars/Bar/Gauge")

func update_life(life):
	player_life_gauge.value = life
	player_life_counter.text = str(life)    
	
func update_score(score):
	player_score_counter.text = str(score)	