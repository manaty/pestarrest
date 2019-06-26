extends Area2D

export var hp = 100
export var status = "alive"

	
func _on_Player_body_entered(body):
	if "Mosquito" in body.name:
		body.feed()

func drain_life(attack):
	hp = hp - attack
	if hp == 0:
		status = "dead"
	print("Player hp: " + str(hp) + " status: " + status)	