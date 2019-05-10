extends KinematicBody2D

signal killed
signal sting

var state="flying"
var target
var velocity=Vector2(200,0)
var tone=0

func init(t):
	tone=t
	print(tone)

func _on_DeathTimer_timeout():
	queue_free()

func _on_Pest_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed()\
	and state == "flying":
		state="dead"
		$DeathTimer.start()
		$AnimatedSprite.animation="squish"
		$bzz.pitch_scale+=tone/13.0
		$bzz.play()
		emit_signal("killed")
		$CollisionShape2D.call_deferred("set_disabled", true)

func pointTo(t):
	state = "attack"
	target = t

func set_speed(s):
	velocity=velocity.normalized()*s

func game_over():
	state="won"
	
func level_passed():
	state="lost"

func _physics_process(delta):
	if(state=="flying"):
		move_and_slide(velocity)
		position+=Vector2(0,-2)+Vector2(0,randi()%5)
	if (state=="attack"):
		var speed = velocity.length()*0.99
		velocity = (target - global_position).normalized() * speed
		rotation+=(target.angle_to_point(global_position)-rotation)*0.1;
		if (scale.length()>0.4):
			move_and_slide(velocity)
			scale*=(1-speed/10000)
		else:
			emit_signal("sting")
			queue_free()
	if (state=="won" or state=="lost"):
		queue_free()