extends Node2D

onready var nav : Navigation2D = $Navigation2D

var path : PoolVector2Array
var path2 : PoolVector2Array
var goal : Vector2
export var speed := 250

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			goal = event.position
			path = nav.get_simple_path($Sprite.position, goal, false)
			path2 = nav.get_simple_path(get_node("Norse-Swordman").get_unit_postion(), goal, false)
			print(path2)
			$Line2D.points = PoolVector2Array(path)
			$Line2D.show()
			
func _process(delta: float) -> void:
	if !path:
		$Line2D.hide()
		return
	if !path2:
		get_node("Norse-Swordman").stop()
	if path.size() > 0:
		var d: float = $Sprite.position.distance_to(path[0])
		if d > 10:
			$Sprite.position = $Sprite.position.linear_interpolate(path[0], (speed * delta)/d)
		else:
			path.remove(0)
	if path2.size() > 0:
		var k: float = get_node("Norse-Swordman").get_distance_to(path2[0])
		if k > 10:
			get_node("Norse-Swordman").move(path2[0], (speed * delta)/k)
		else:
			path2.remove(0)
