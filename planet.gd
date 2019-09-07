extends Node2D

var G = 400.0
var velocity = Vector2(0,2)


func acceleration(pos1, pos2, Gforce):
	var direction = Vector2(pos1.x - pos2.x, pos1.y - pos2.y)
	var lenght = sqrt(pow(direction.x, 2)+pow(direction.y, 2))
	var normal = Vector2(direction.x/lenght, direction.y/lenght)
	return Vector2(normal.x*(Gforce/pow(lenght,2)),normal.y*(Gforce/pow(lenght,2)))

func step_euler(sunCenter, Gforce):
	var step = 100
	var acc = Vector2(0,0)
	for i in range(step):
		var dt = 1.0/step
		acc = acceleration(sunCenter, position, Gforce)
		velocity = Vector2(velocity.x+acc.x*dt,velocity.y+acc.y*dt)
		position = Vector2(position.x+velocity.x*dt,position.y + velocity.y*dt)
	

func _process(delta):
	var sun = get_parent().get_node("sun")
	step_euler(sun.position, abs(sun.G-G))
	update()
	
func _draw():
	draw_vector( Vector2(0,0), velocity*100, Color(1,1,1,0.3), 2 )
	
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
		
func get_G():
	return G;