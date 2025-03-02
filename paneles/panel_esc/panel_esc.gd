extends Control

# Botón "Salir al Menú"
func _on_button_salir_menu_pressed():
	get_tree().change_scene_to_file("res://paneles/panel_menuprincipal/menu_principal.tscn")  

# Botón "Salir al Escritorio"
func _on_button_salir_escritorio_pressed():
	get_tree().quit()  # Cierra el juego

# Botón "X" para cerrar el menú
func _on_button_cerrar_pressed():
	queue_free()  # Elimina la instancia del menú de confirmación
