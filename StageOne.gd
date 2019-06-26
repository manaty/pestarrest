extends Node2D

export (PackedScene) var Mosquito
onready var MosquitoContainer = get_node("MosquitoContainer")

var screensize
var level = 1
var spawnLimit = 50
var playerScore = 0
var damage = 3

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$GameHUD.update_life($Player.hp)
	$GameHUD.update_score(playerScore)
	set_process(true)
	
	$StartTimer.start()

func _on_StartTimer_timeout():	
	$SpawnMosquitoTimer.start()
	
func spawn_mosquitoes(num):	
	for i in range(num):
		$MosquitoPath/MosquitoSpawnLocation.offset = randi()
		var mosquito = Mosquito.instance()
		MosquitoContainer.add_child(mosquito)
		mosquito.position = $MosquitoPath/MosquitoSpawnLocation.position
		mosquito.connect("killed", self, "_on_Mosquito_Killed")
		mosquito.connect("feed", self, "_on_Mosquito_Feed")
		spawnLimit-=1

func _on_Mosquito_Killed():	
	playerScore += 1
	print(playerScore)
	$GameHUD.update_score(playerScore)
	

func _on_Mosquito_Feed():
	print("Yummy ...")	
	$Player.drain_life(damage)
	$GameHUD.update_life($Player.hp)

func _on_SpawnMosquitoTimer_timeout():	
	if spawnLimit > 0:
		spawn_mosquitoes(2)
	else:
		pass