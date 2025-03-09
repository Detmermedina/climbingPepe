extends Node2D  # O Control, según el nodo raíz

var time_elapsed: int = 0  # Variable para almacenar el tiempo transcurrido

func _ready():
	$Timer.start()  # Iniciar el Timer al comienzo
	update_label()  # Actualizar la pantalla inicialmente

func update_label():
	$Label.text = "Tiempo: " + str(time_elapsed)  # Mostrar el tiempo en pantalla

func _on_timer_timeout() -> void:  # Asegúrate de que el nombre coincide con el nodo Timer
	time_elapsed += 1  # Incrementa el tiempo
	update_label()  # Actualizar el Label con el nuevo valor
