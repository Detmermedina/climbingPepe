extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_altura_pressed() -> void:
	get_tree().change_scene_to_file("res://mapa/nivel1/nivel1.tscn")


func _on_button_tiempo_pressed() -> void:
	get_tree().change_scene_to_file("res://mapa/nivel2/nivel2.tscn")


func _on_button_salir_pressed() -> void:
	get_tree().quit()
