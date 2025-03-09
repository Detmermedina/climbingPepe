extends CanvasLayer

signal restart

func _on_restart_button_pressed() -> void:
	restart.emit()  # Emitir la señal (por si algún otro nodo la usa)
	get_tree().change_scene_to_file("res://paneles/panel_menuprincipal/menu_principal.tscn")  # Cambiar a la escena principal
