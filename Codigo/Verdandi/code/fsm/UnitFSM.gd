extends AnimationTree

var CORE

func _ready():
	self["parameters/conditions/LOOK_N"] = (get_parent().unit_stats.my_orientation == 0)
	self["parameters/conditions/LookNE"] = (get_parent().unit_stats.my_orientation == 1)
	self["parameters/conditions/LookE"] = (get_parent().unit_stats.my_orientation == 2)
	self["parameters/conditions/LookSE"] = (get_parent().unit_stats.my_orientation == 3)
	self["parameters/conditions/LookS"] = (get_parent().unit_stats.my_orientation == 4)
	self["parameters/conditions/LookSW"] = (get_parent().unit_stats.my_orientation == 5)
	self["parameters/conditions/LookW"] = (get_parent().unit_stats.my_orientation == 6)
	self["parameters/conditions/LookNW"] = (get_parent().unit_stats.my_orientation == 7)
	CORE = get("parameters/playback")
	CORE.start("BRAIN")
