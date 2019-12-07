extends Node2D

func _ready():
	get_node("BackRect/VContainer/HCMusic/MButton/ButtonMusic").text = "KEY_NO" if DataManager.user_data.configuration.sound else "KEY_YES"
	get_node("BackRect/VContainer/HCLanguage/MButton/ButtonLanguage").text = "EN" if TranslationServer.get_locale() == "en" else "ES"
	get_node("BackRect/VContainer/HCScreen/MButton/ButtonScreen").text = "KEY_YES" if DataManager.user_data.configuration.fullscreen else "KEY_NO"

func _on_ButtonMusic_pressed():
	if DataManager.user_data.configuration.sound:
		get_node("BackRect/VContainer/HCMusic/MButton/ButtonMusic").text = "KEY_YES"
		DataManager.user_data.configuration.sound = false
	else:
		get_node("BackRect/VContainer/HCMusic/MButton/ButtonMusic").text = "KEY_NO"
		DataManager.user_data.configuration.sound = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), DataManager.user_data.configuration.sound)
	DataManager.save_user_data_encrypted()

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

func _on_ButtonScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	DataManager.user_data.configuration.fullscreen = OS.window_fullscreen
	get_node("BackRect/VContainer/HCScreen/MButton/ButtonScreen").text = "KEY_YES" if DataManager.user_data.configuration.fullscreen else "KEY_NO"
	DataManager.save_user_data_encrypted()

