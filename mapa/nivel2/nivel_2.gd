extends Node2D  # O Control, según el nodo raíz

var time_elapsed: int = 3  # Variable para almacenar el tiempo

func _ready():
	$Timer.start()  # Iniciar el Timer al comienzo
	update_label()  # Actualizar la pantalla inicialmente
	
func update_label():
	$Label.text = "Tiempo restante: " + str(time_elapsed)  # Muestra el tiempo en pantalla

func _on_timer_timeout() -> void:
	if time_elapsed > 0:  
		time_elapsed -= 1
		update_label()
	else:
		$Timer.stop()  # Detener el Timer
		get_tree().change_scene_to_file("res://paneles/panel_gameover/game_over_menu.tscn")  # Cambiar de escena
