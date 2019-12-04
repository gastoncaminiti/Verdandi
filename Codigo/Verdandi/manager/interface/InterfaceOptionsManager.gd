extends Node2D

func _ready():
	if DataManager.user_data.configuration.sound:
		get_node("BackRect/VContainer/HCLanguage2/MButton/ButtonMusic").text = "KEY_YES"
	else:
		get_node("BackRect/VContainer/HCLanguage2/MButton/ButtonMusic").text = "KEY_NO"
	if TranslationServer.get_locale() == "en":
		get_node("BackRect/VContainer/HCLanguage/MButton/ButtonLanguage").text = "EN"
	else:
		get_node("BackRect/VContainer/HCLanguage/MButton/ButtonLanguage").text = "ES"

func _on_ButtonMusic_pressed():
	if DataManager.user_data.configuration.sound:
		get_node("BackRect/VContainer/HCLanguage2/MButton/ButtonMusic").text = "KEY_NO"
		DataManager.user_data.configuration.sound = false
	else:
		get_node("BackRect/VContainer/HCLanguage2/MButton/ButtonMusic").text = "KEY_YES"
		DataManager.user_data.configuration.sound = true
	DataManager.update_data()

func _on_ButtonLanguage_pressed():
	if TranslationServer.get_locale() == "en":
		get_node("BackRect/VContainer/HCLanguage/MButton/ButtonLanguage").text = "ES"
		DataManager.user_data.configuration.language = "es"
		TranslationServer.set_locale("es")
	else:
		get_node("BackRect/VContainer/HCLanguage/MButton/ButtonLanguage").text = "EN"
		DataManager.user_data.configuration.language = "en"
		TranslationServer.set_locale("en")
	DataManager.save_user_data_encrypted()
	
func _on_Exit_pressed():
	queue_free()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		queue_free()