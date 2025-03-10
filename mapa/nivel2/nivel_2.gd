extends Node2D  # O Control, según tu nodo raíz

var time_elapsed: int = 5  # Segundos iniciales

func _ready():
	call_deferred("_set_window_size")
	$Timer.start()  # Iniciar el Timer al comienzo
	update_label()  # Actualizar la pantalla inicialmente

func _set_window_size() -> void:
	var window_size = Vector2(650, 648)
	get_tree().root.set_size(window_size)
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
	
	var screen_size = Vector2(DisplayServer.screen_get_size())  
	var position = (screen_size - window_size) / 2
	DisplayServer.window_set_position(position)

func _on_timer_timeout():
	if time_elapsed > 0:  
		time_elapsed -= 1
		update_label()
	else:
		$Timer.stop()  # Detener el Timer
		get_tree().change_scene_to_file("res://paneles/panel_gameover_nivel2/derrotaN2.tscn")  # Cambiar de escena

func update_label():
	$Label.text = "Tiempo restante: " + str(time_elapsed)  # Mostrar tiempo en pantalla
