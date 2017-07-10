extends Node2D

var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)

# Constant for pad speed (in pixels/second)
const INITIAL_BALL_SPEED = 80
# Speed of the ball (also in pixels/second)
var ball_speed = INITIAL_BALL_SPEED
# Constant for pads speed
const PAD_SPEED = 150

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	set_process(true)

func _process(delta):
    var ball_pos = get_node("ball").get_pos()
    var left_rect = Rect2( get_node("left").get_pos() - pad_size*0.5, pad_size )
    var right_rect = Rect2( get_node("right").get_pos() - pad_size*0.5, pad_size )
	#integrate new ball position
    ball_pos += direction * ball_speed * delta