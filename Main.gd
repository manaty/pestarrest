extends Node2D

signal game_over
signal level_passed

var sol0=-2
var la0=-1
var si0=-0.5
var do=0
var re=2
var mi=4

export (PackedScene) var Pest
var speed = 200
var score = 0
var pest_number=50
var step=0
var life=5
var level=1
var music_scale=[re,sol0,sol0,re,do,si0,la0,sol0,\
 do,do,do,re,mi,re,do,mi,re,re,do\
,do,do,do,re,mi,re,do,mi,re,re,do]

func _ready():
	randomize()
	$HUD.update_life(life)	

func get_init_speed():
	return level*200
	
func get_init_pest_number():
	return 50+level*10;

func _on_HUD_start_game():
	speed=get_init_speed()
	$HUD.update_score(score)
	$StartTimer.start()

func _on_StartTimer_timeout():
	$PestTimer.start()

func _on_PestTimer_timeout():
    # Create a Pest instance and add it to the scene.
	var pest = Pest.instance()
	pest.init(music_scale[step%music_scale.size()])
	step+=1
	pest_number-=1
	add_child(pest)
	pest.position=Vector2(0,200+200*(randi()%4))
	pest.set_speed(speed)
	pest.connect("killed",self,"_on_Pest_Killed")
	pest.connect("sting",self,"_on_Player_Stung")
	self.connect("game_over",pest,"game_over")
	self.connect("level_passed",pest,"level_passed")
	if($PestTimer.wait_time>0.5):
		$PestTimer.wait_time*=0.95
   
func _on_Pest_Killed():
	score+=1
	if(speed<(1000+level*100)):
		speed+=10
	$HUD.update_score(score)	
	if(pest_number<0):
		level_passed()

func _on_Player_Stung():
	life-=1
	$aie.play()
	$HUD.update_life(life)	
	$PestTimer.wait_time+=0.1
	if(speed>200):
		speed-=100
	if(life<=0):
		game_over()

func _on_StingZone_body_entered(body):
	body.pointTo($StingZone/Face.global_position)

func init_game():
	score=0
	level=1
	life=5
	$HUD.update_life(life)	
	$GUI/HBoxContainer/Bars/Bar/Gauge.max_value = life	
	
	
func init_level():
	step=0
	speed=get_init_speed()
	pest_number=get_init_pest_number()
	$PestTimer.stop()
	$PestTimer.wait_time=1

func game_over():
	init_game()
	init_level()
	emit_signal("game_over")
	$HUD.show_game_over()

func level_passed():
	level+=1
	init_level()
	emit_signal("level_passed")
	$HUD.show_level_passed()