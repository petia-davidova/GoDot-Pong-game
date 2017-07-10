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
	#This code line is called at each iteration of the _process() function. 
	#That means the ball position will be updated at each new frame.
    ball_pos += direction * ball_speed * delta

	#Now that the ball has a new position, we need to test if it collides with anything, 
	#that is the window borders and the pads. 
	#First, the floor and the roof:
	# Flip when touching roof or floor
    if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
    	direction.y = -direction.y

	#Second, the pads: if one of the pads is touched, we need to invert the direction 
	#of the ball on the X axis so it goes back, and define a new random Y direction using the randf() function. 
	#We also increase its speed a little.
	# Flip, change direction and increase speed when touching pads
    if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
        direction.x = -direction.x
        direction.y = randf()*2.0 - 1
        direction = direction.normalized()
        ball_speed *= 1.1

	#Finally, if the ball went out of the screen, it’s game over. 
	#That is, we test if the X position of the ball is less than 0 or greater than the screen width. 
	#If so, the game restarts.
    if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
        ball_pos = screen_size*0.5
        ball_speed = INITIAL_BALL_SPEED
        direction = Vector2(-1, 0)

    #Once everything is done, the node is updated with the new position of the ball, which was computed before.
    get_node("ball").set_pos(ball_pos)	

    # Move left pad
    var left_pos = get_node("left").get_pos()
    if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
        left_pos.y += -PAD_SPEED * delta
    if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
        left_pos.y += PAD_SPEED * delta
    get_node("left").set_pos(left_pos)

    # Move right pad
    var right_pos = get_node("right").get_pos()
    if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
        right_pos.y += -PAD_SPEED * delta
    if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
        right_pos.y += PAD_SPEED * delta
    get_node("right").set_pos(right_pos)