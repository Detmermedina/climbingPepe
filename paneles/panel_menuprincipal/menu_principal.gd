extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("_set_window_size")
	

func _set_window_size() -> void:
	var window_size = Vector2(1150, 600)
	get_tree().root.set_size(window_size)
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
	
	var screen_size = Vector2(DisplayServer.screen_get_size()) 
	var position = (screen_size - window_size) / 2
	DisplayServer.window_set_position(position)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_altura_pressed() -> void:
	get_tree().change_scene_to_file("res://mapa/nivel1/nivel1.tscn")


func _on_button_tiempo_pressed() -> void:
	get_tree().change_scene_to_file("res://mapa/nivel2/nivel2.tscn")


func _on_button_salir_pressed() -> void:
	get_tree().quit()
