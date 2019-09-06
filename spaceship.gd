extends Node2D

const angular_acc = 0.01
var angular_velocity = 0.0
var velocity = Vector2( 1.0, 0.0 )

var facing   = Vector2( 0.0, 0.0 )
var orientation = 0 

var thrust   = 1
var vector_to_mouse = Vector2( 0, 0 )

func _process( delta ):
	process_input( delta )
	vector_to_mouse = get_global_mouse_position() - position
	var angle_to_mouse = atan2(facing.x*vector_to_mouse.y - facing.y*vector_to_mouse.x,
							   facing.x*vector_to_mouse.x + facing.y*vector_to_mouse.y )
	angular_velocity += angle_to_mouse * 0.01
	angular_velocity *= 0.93
	orientation += angular_velocity
	facing = Vector2( cos(orientation), sin(orientation) )

	velocity += facing * thrust
	velocity *= 0.94
	position += velocity
	
	$body.rotation = orientation
	update()

func process_input( delta ):
	thrust = 0
	if Input.is_action_pressed("ui_up"):
		thrust = 1
		$body/AnimationPlayer.play("thrust")
		
	if Input.is_action_pressed("ui_down"):
		thrust = -1
		$body/AnimationPlayer.play("thrust")

	if Input.is_action_pressed("ui_left"):
		angular_velocity -= angular_acc
	if Input.is_action_pressed("ui_right"):
		angular_velocity += angular_acc

func _draw():
	draw_vector( Vector2(), facing  * 100, Color(1,1,1,0.3), 2 )
	draw_vector( Vector2(), velocity * 4, Color(1,0,0,0.3), 2 )
	draw_vector( Vector2(), vector_to_mouse * 0.5, Color(0,1,0,0.3), 2 )

func draw_vector( origin, vector, color, arrow_size ):
	if vector.length_squared() > 1:
		var points    = []
		var direction = vector.normalized()
		vector += origin
		vector -= direction * arrow_size*2
		points.push_back( vector + direction * arrow_size*2  )
		points.push_back( vector + direction.rotated(  PI / 1.5 ) * arrow_size * 2 )
		points.push_back( vector + direction.rotated( -PI / 1.5 ) * arrow_size * 2 )
		draw_polygon( PoolVector2Array( points ), PoolColorArray( [color] ) )
		vector -= direction * arrow_size*1
		draw_line( origin, vector, color, arrow_size )