extends Node

signal restart



func _on_restart_button_pressed() -> void:
	restart.emit()
	



func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://paneles/panel_menuprincipal/menu_principal.tscn")


func _on_boton_salir_escritorio_pressed() -> void:
	pass # Replace with function body.
