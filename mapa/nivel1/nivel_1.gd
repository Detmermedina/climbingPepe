extends Node2D

var time_elapsed: int = 0  # Variable para almacenar el tiempo transcurrido

func _ready():
	pass # Replace with function body.
	# Establecer el tamaño de la ventana en el nivel 1
	get_tree().root.set_size(Vector2(650, 648))
	$Timer.start()  # Iniciar el Timer al comienzo
	update_label()  # Actualizar la pantalla inicialmente

func update_label():
	$Label.text = "Tiempo: " + str(time_elapsed)  # Mostrar el tiempo en pantalla

func _on_timer_timeout() -> void:  
	time_elapsed += 1  # Incrementa el contador cada segundo
	update_label()  

# Función para obtener el tiempo cuando se termine el nivel
func get_final_time() -> int:
	return time_elapsed
