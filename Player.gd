extends Area2D

signal player_died

var hp = 100
export var status = "alive"

func _physics_process(delta):
	if hp <= 0 && status == "alive":		
		emit_signal("player_died")
		status = "dead"
	
func _on_Player_body_entered(body):
	if "Mosquito" in body.name:
		body.feed()

func init_life():
	hp = 100
	status = "alive"		

func drain_life(attack):
	hp = hp - attack
	if hp == 0:
		status = "dead"		