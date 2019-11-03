extends Node2D

export(PackedScene)  var open_scene

func _ready():
	$AnimationPlayer.play("idle")
