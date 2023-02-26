extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false

var powerup_prob = 0.1

func _ready():
	#$ColorRect.set_size(Vector2(90,30))
	$CollisionShape2D.shape.extents = Vector2(90,30)
	randomize()
	position = new_position
#	if(score>=100):
#		$ColorRect.color = Color8(255,0,0)
#	elif(score>=50):
#		$ColorRect.color = Color8(255,255,0)
#	elif(score>=0):
#		$ColorRect.color = Color8(255,0,255)
		
func _physics_process(_delta):
	if dying:
		queue_free()

func hit(_ball):
	var brick_sound = get_node_or_null("/root/Game/Brick_Sound")
	if brick_sound != null:
		brick_sound.play()
	die()

func die():
	dying = true
	collision_layer = 0
	#$ColorRect.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instance()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
