extends Node

# ------------------ DATAMANAGER SCRIPT ------------------
# Singleton manejador de la persistencia de datos del jugador y progresión.
var user_local_filename    = "user://data_verdandi.bin"
var data_template_filename = "res://data/user.json"
var user_data    = {}
# Contenidor de niveles disponibles al jugador
var maped_levels = {
	"00": "res://level/sigurd/Level0.tscn",
	"01": "res://level/sigurd/Level1.tscn",
	"02": "res://level/sigurd/Level2.tscn",
	"03": "res://level/sigurd/Level3.tscn"
}

# Función: Determinar si existe el archivo de persistencia. Si es necesario crea una copia con el formato requerido
func _ready():
	if(is_user_data_local()):
		get_user_data_encrypted()
	else:
		get_data_template()
		save_user_data_encrypted()

# Función: Obtener estructura de datos a almacenar.
func get_data_template():
	var file = File.new()
	var err = file.open(data_template_filename, File.READ)
	if err == OK:
		var json = JSON.parse(file.get_as_text())
		if json.error == OK:
			user_data = json.result
	file.close()

# Función: Guardar datos de usuario en archivo de persistencia con ID de verificacion.
func save_user_data_encrypted():
	var file = File.new()
	var err  = file.open_encrypted_with_pass(user_local_filename, File.WRITE, OS.get_unique_id())
	if err == OK:
		file.store_line(to_json(user_data))
	file.close()

# Función: Obtener datos de usuario en archivo de persistencia con ID de verificacion.
func get_user_data_encrypted():
	var file = File.new()
	var err  = file.open_encrypted_with_pass(user_local_filename, File.READ, OS.get_unique_id())
	if err == OK:
		var json = JSON.parse(file.get_as_text())
		if json.error == OK:
			user_data = json.result
	file.close()

# Función: Verificación de existencia de archivo de usuario.
func is_user_data_local():
	var file = File.new()
	return file.file_exists(user_local_filename)
