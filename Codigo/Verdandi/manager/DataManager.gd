extends Node

var user_data

func _ready():
	get_data()

func get_data():
	var file = File.new()
	var err = file.open("res://data/user.json", File.READ)
	if err == OK:
		var json = JSON.parse(file.get_as_text())
		if json.error == OK:
			user_data = json.result
	
func update_data():
	var file = File.new()
	var err = file.open("res://data/user.json", File.WRITE)
	if err == OK:
		file.store_line(to_json(user_data))
		file.close()
	get_data()