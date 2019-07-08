extends Node2D

export (PackedScene) var Mosquito
onready var MosquitoContainer = get_node("MosquitoContainer")
onready var GameHUD = get_node("GameHUD")

const SPAWN_LIMIT = 20
const SPAWN_COUNT = 5
const BOSS_HP = 10

const MOSQUITO_STATES = {
	"FLYING": "flying",
	"ATTACKING": "attacking",
	"SATED": "sated",
	"DEAD": "dead"
};

var screensize
var level = 1
var spawnRemaining = SPAWN_LIMIT
var spawnCount = SPAWN_COUNT
var playerScore = 0
var gameStatus = "active"
var spawnedMosquito = 0

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
	spawnedMosquito = 0
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
	
func spawn_boss():
		var mosquito = Mosquito.instance()
		mosquito.set_type("BOSS")
		mosquito.set_hp(BOSS_HP)
		mosquito.connect("killed", self, "_on_Mosquito_Killed")
		mosquito.connect("deal_damage", self, "_on_Deal_Damage", [mosquito])
		mosquito.connect("boss_defeated", self, "_on_Boss_Defeated")
		MosquitoContainer.add_child(mosquito)
		mosquito.position = Vector2(0,0)
		
	
func spawn_mosquitoes(num):	
	for i in range(num):		
		$MosquitoPath/MosquitoSpawnLocation.offset = randi()
		var mosquito = Mosquito.instance()
		mosquito.get_node("AnimatedSprite").scale = Vector2(0.4, 0.4)
		MosquitoContainer.add_child(mosquito)
		mosquito.position = $MosquitoPath/MosquitoSpawnLocation.position
		mosquito.connect("killed", self, "_on_Mosquito_Killed")
		mosquito.connect("feed", self, "_on_Mosquito_Feed", [mosquito])
		spawnRemaining-=1
		spawnedMosquito += 1				

func _on_Boss_Defeated():
	GameHUD.show_level_won()
	
func _on_Deal_Damage(mosquito):
	$Player.drain_life(mosquito.damage)
	$GameHUD.update_life($Player.hp)		
	
func _on_Mosquito_Killed():	
	playerScore += 1
	$GameHUD.update_score(playerScore)
	
func _on_Mosquito_Feed(mosquito):
	if mosquito.get("state") == MOSQUITO_STATES.ATTACKING:
		$Player.drain_life(mosquito.damage)
		$GameHUD.update_life($Player.hp)		

func level_respawn():
	GameHUD.hide_msg_label()
	var spawnCounter = SPAWN_LIMIT * level
	spawnCount = SPAWN_COUNT * level
	if spawnRemaining > 0 && spawnedMosquito < spawnCounter && level < 3:
		spawn_mosquitoes(spawnCount)		
	elif level == 3:
		free_all_mosquitoes()
		GameHUD.game_start_message("The mosquito boss is coming...")	
		$SpawnMosquitoTimer.stop()
		$BossTimer.start()		
	else:		
		level += 1
		spawnRemaining = spawnCounter * level
		spawnedMosquito = 0		
		if level < 3:
			free_all_mosquitoes()
			GameHUD.game_start_message("A new wave is coming...")
		
func _on_SpawnMosquitoTimer_timeout():	
	level_respawn()
	$Lullaby.stop()

func _on_Player_player_died():
	$GameOver.play()
	GameHUD.show_game_over()
	kill_all_mosquitoes()
	$SpawnMosquitoTimer.stop()
	
func kill_all_mosquitoes():
	for i in MosquitoContainer.get_children():
		i.queue_free()

func free_all_mosquitoes():				
	for i in MosquitoContainer.get_children():
		i.set_state(MOSQUITO_STATES.SATED)
		
func retry():
	GameHUD.hide_game_over()
	$GameOver.stop()
	kill_all_mosquitoes()
				
func _on_GameHUD_retry():
	retry()
	init_game()
	start_game()


func _on_BossTimer_timeout():
	GameHUD.hide_msg_label()
	spawn_boss()
