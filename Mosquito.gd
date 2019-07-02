extends KinematicBody2D

signal killed
signal feed

const MIN_SPEED = 100  # Minimum speed range
const MAX_SPEED = 500  # Maximum speed range
const STATES = {
	"FLYING": "flying",
	"ATTACKING": "attacking",
	"SATED": "sated",
	"DEAD": "dead"
};

export var damage = 3 # Mosquito damage per bite
var speed = rand_range(MIN_SPEED, MAX_SPEED)

var state= STATES.FLYING
var direction = 1
var yDirection = 1
var screensize
var velocity = Vector2(rand_range(0, 1200), rand_range(0, 700))
var bloodCount = 0

func _ready():
	randomize()
	$AnimatedSprite.play(STATES.FLYING)
	$AnimatedSprite.scale = Vector2(0.4, 0.4)
	$Buzz.play()
	screensize = get_viewport_rect().size
	
func _physics_process(delta):	
	if direction == 1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
		
	if state == STATES.FLYING:
		velocity.x = speed * direction
		velocity.y = speed * yDirection
		
		velocity = move_and_slide(velocity)
				
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				var pest = get_slide_collision(i).collider
				if "Mosquito" in pest.name:										
					if pest.get("state") == STATES.ATTACKING || pest.get("state") == STATES.SATED:
						add_collision_exception_with(pest)
					else:	
						direction = direction * -1
						yDirection = yDirection * - 1
		
		if position.x > screensize.x || position.x < 0:
			direction = direction * -1
		
		if position.y < 0 	|| position.y > screensize.y:
			yDirection = yDirection * - 1	
											
	elif state== STATES.SATED:
		velocity.x = (speed * 3) * direction
		velocity = move_and_slide(velocity)						


func _on_Mosquito_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed()\
	and (state == STATES.FLYING || state == STATES.ATTACKING || state==STATES.SATED) :		
		state=STATES.DEAD
		$AnimatedSprite.play("squish")
		emit_signal("killed")
		$CollisionShape2D.queue_free()
		$Splat.play()
		$Buzz.queue_free()
		$DeathTimer.start()
				
			
func feed():	
	state = STATES.ATTACKING			
	$FeedTimer.start()

func set_damage(dmg):
	damage = dmg

func _on_DeathTimer_timeout():
	queue_free()

func _on_Buzz_finished():
	$Buzz.play()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_FeedTimer_timeout():			
	if bloodCount >= 15: 
		state = STATES.SATED
		$FeedTimer.stop()
	else:
		bloodCount += damage
		emit_signal("feed")

