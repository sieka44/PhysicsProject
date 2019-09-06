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
	for i in range(step):
		var dt = 1.0/step
		var acc = acceleration(sunCenter, position, Gforce)
		velocity = Vector2(velocity.x+acc.x*dt,velocity.y+acc.y*dt)
		position = 1.000001*Vector2(position.x+velocity.x*dt,position.y + velocity.y*dt)

func _process(delta):
	var sun = get_parent().get_node("sun")
	step_euler(sun.position, abs(sun.G-G))
	update()