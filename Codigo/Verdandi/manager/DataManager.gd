extends Node

var user_data

func _ready():
	var file = File.new()
	var err = file.open("res://data/user.json", File.READ)
	if err == OK:
		var json = JSON.parse(file.get_as_text())
		if json.error == OK:
			user_data = json.result
