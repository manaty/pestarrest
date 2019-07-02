extends Node2D

export (PackedScene) var Mosquito
onready var MosquitoContainer = get_node("MosquitoContainer")
onready var GameHUD = get_node("GameHUD")

const SPAWN_LIMIT = 100
const SPAWN_COUNT = 5


var screensize
var level = 1
var spawnLimit = SPAWN_LIMIT
var spawnCount = SPAWN_COUNT
var playerScore = 0
var gameStatus = "active"

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size	
	init_game()
	set_process(true)		

func init_game():
	level = 1
	playerScore = 0
	spawnCount = SPAWN_COUNT
	gameStatus = "active"
	$Player.init_life()	
	$Lullaby.play()
	start_game()
	
func start_game():
	GameHUD.hide_game_over()
	GameHUD.game_start_message("Mosquitoes are coming...")
	GameHUD.update_life($Player.hp)
	GameHUD.update_score(playerScore)
	$StartTimer.start()	

func _on_StartTimer_timeout():	
	GameHUD.hide_msg_label()	
	$SpawnMosquitoTimer.start()
	
func spawn_mosquitoes(num):	
	for i in range(num):
		$MosquitoPath/MosquitoSpawnLocation.offset = randi()
		var mosquito = Mosquito.instance()
		MosquitoContainer.add_child(mosquito)
		mosquito.position = $MosquitoPath/MosquitoSpawnLocation.position
		mosquito.connect("killed", self, "_on_Mosquito_Killed")
		mosquito.connect("feed", self, "_on_Mosquito_Feed", [mosquito])
		spawnLimit-=1

func _on_Mosquito_Killed():	
	playerScore += 1
	$GameHUD.update_score(playerScore)
	
func _on_Mosquito_Feed(mosquito):
	if mosquito.get("state") == "attacking":
		$Player.drain_life(mosquito.damage)
		$GameHUD.update_life($Player.hp)

func _on_SpawnMosquitoTimer_timeout():	
	if spawnLimit > 0:
		spawn_mosquitoes(spawnCount)	
	$Lullaby.stop()

func _on_Player_player_died():
	$GameOver.play()
	GameHUD.show_game_over()
	kill_all_mosquitoes()
	$SpawnMosquitoTimer.stop()
	
func kill_all_mosquitoes():
	for i in MosquitoContainer.get_children():
		i.queue_free()	

func retry():
	GameHUD.hide_game_over()
	$GameOver.stop()
	kill_all_mosquitoes()
				
func _on_GameHUD_retry():
	retry()
	init_game()
	start_game()
