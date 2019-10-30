extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_parent_child("units_moved","_goOrder")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _goOrder(nav):
	var avatar = get_node("Layer 2 - GUI/Sidgrida/AnimatedSprite")
	var bag    = get_node("Layer 2 - GUI/Bag")
	avatar.play("atack")
	avatar.set_frame(0)
	bag.play("open")
	bag.set_frame(0)

# Función que permite conectar una señal de nodo padre con una función del nodo hijo.
func connect_parent_child(nsignal, nfunction):
	if get_parent().is_in_group("Level"):
		if get_parent().connect(nsignal,self,nfunction) != OK:
			print("Error al conectar "+ name +" con el padre - Señal "+nsignal+" Función "+nfunction)
