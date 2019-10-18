extends Node

func get_unit_postion():
	return $AnimatedSprite.global_position

func get_distance_to(distance):
	return $AnimatedSprite.global_position.distance_to(distance)

func move(point, speed):
	$AnimatedSprite.global_position = $AnimatedSprite.global_position.linear_interpolate(point, speed)
	set_animated("walk_down")

func set_animated(name):
	$AnimatedSprite.play(name)

func stop():
	print("P")
	set_animated("default")