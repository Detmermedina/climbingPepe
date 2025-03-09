extends Node2D

var time_elapsed: int = 0  # Variable para almacenar el tiempo transcurrido

func _ready():
	pass # Replace with function body.
	# Establecer el tamaño de la ventana en el nivel 1
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

func update_label():
	$Label.text = "Tiempo: " + str(time_elapsed)  # Mostrar el tiempo en pantalla

func _on_timer_timeout() -> void:  
	time_elapsed += 1  # Incrementa el contador cada segundo
	update_label()  

# Función para obtener el tiempo cuando se termine el nivel
func get_final_time() -> int:
	return time_elapsed
