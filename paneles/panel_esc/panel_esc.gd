extends CanvasLayer

# Botón "X" para cerrar el menú
func _on_button_cerrar_pressed():
	queue_free()  # Elimina la instancia del menú de confirmación


func _on_boton_salir_escritorio_pressed() -> void:
	get_tree().change_scene_to_file("res://paneles/panel_menuprincipal/menu_principal.tscn")  
	


func _on_boton_salir_menu_pressed() -> void:
	get_tree().quit() # Replace with function body.
	


func _on_boton_x_pressed() -> void:
	queue_free()# Replace with function body.
