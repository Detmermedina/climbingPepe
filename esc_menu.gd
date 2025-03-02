extends Node

var panel_esc = preload("res://paneles/panel_esc/panel_esc.tscn")
var niveles_permitidos = ["res://mapa/nivel1/nivel1.tscn", "res://mapa/nivel2/nivel2.tscn"]

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var current_scene = get_tree().current_scene.scene_file_path  # Obtiene la ruta de la escena actual
		if current_scene in niveles_permitidos:  # Solo ejecuta si la escena está en la lista
			if not get_tree().current_scene.has_node("SalirMenu"):  # Evita duplicados
				var panel_instance = panel_esc.instantiate()
				get_tree().current_scene.add_child(panel_instance)
