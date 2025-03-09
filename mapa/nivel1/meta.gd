extends Area2D

@export var next_level: String = "res://nivel2.tscn"  # Ruta del siguiente nivel

# Se ejecuta cuando un cuerpo entra en la zona
func _on_body_entered(body):
	get_tree().change_scene_to_file("res://paneles/panel_gameover/game_over_menu.tscn")  # Cambia de nivelel)
