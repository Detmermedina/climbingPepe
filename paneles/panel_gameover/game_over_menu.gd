extends Node

signal restart



func _on_restart_button_pressed() -> void:
	restart.emit()
	


func _on_pressed_jugar() -> void:
	get_tree().change_scene_to_file("res://mapa/nivel1/nivel1.tscn") # Replace with function body.


func _on_boton_salir_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://paneles/panel_menuprincipal/menu_principal.tscn")# Replace with function body.
