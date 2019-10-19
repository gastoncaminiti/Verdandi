extends KinematicBody2D

var cursor

func get_unit_postion():
	return global_position

func get_distance_to(distance):
	return global_position.distance_to(distance)

func move(point, speed):
	global_position = global_position.linear_interpolate(point, speed)
	if abs(cursor) > 5:
		set_animated("walk_side")
	else:
		set_animated("walk_down")
	
func set_animated(name):
	$AnimatedSprite.play(name)

func set_cursor(angle):
	cursor = rad2deg(angle)
	print($Area2D/CollisionPolygon2D.polygon)

func stop():
	set_animated("default")