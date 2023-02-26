extends KinematicBody2D

var target = Vector2.ZERO
export var speed = 10.0
var width = 0
var width_default = 0
var decay = 0.02

func _ready():
	
	if Global.level < 0 or Global.level >= len(Levels.levels):
		pass
	else:
		var level_paddle_size = Levels.levels[Global.level].paddle_size
		$CollisionShape2D.scale = $CollisionShape2D.scale*level_paddle_size
		$Highlight.scale = Vector2(0.086*level_paddle_size,0.086*1.1)*1.1
		$Sprite.scale = Vector2(0.12*level_paddle_size,0.12*1.1)*1.1
		width = $CollisionShape2D.get_shape().get_extents().x
		width_default = width
		target = Vector2(Global.VP.x / 2, Global.VP.y - 80)

	


func _physics_process(_delta):
	target.x = clamp(target.x, 0, Global.VP.x - 2*width)
	position = target
	if $Highlight.modulate.a > 0:
		$Highlight.modulate.a -= decay		
	for c in $Powerups.get_children():
		c.payload()


func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x

func hit(_ball):
		$Highlight.modulate.a = 1.0
		$Confetti.emitting = true
		var paddle_sound = get_node_or_null("/root/Game/Lillypad")
		if paddle_sound != null:
			paddle_sound.play()

func powerup(payload):
	for c in $Powerups.get_children():
		if c.type == payload.type:
			c.queue_free()
	$Powerups.call_deferred("add_child", payload)
