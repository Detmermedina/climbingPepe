extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://paneles/panel_menuprincipal/menu_principal.tscn")


func _on_boton_jugar_de_nuevo_pressed() -> void:
	pass # Replace with function body.
