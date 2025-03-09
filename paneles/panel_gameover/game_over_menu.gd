extends Node

var time_elapsed: int 

func set_time_elapsed(time: int):
	print("✅ Tiempo recibido en panel de derrota:", time)
	time_elapsed = time  # Guardamos el tiempo recibido
	print("", time_elapsed)
	call_deferred("update_label")  # Asegura que se ejecuta cuando todo esté listo

func _ready() -> void:
	print("🏁 Panel de derrota cargado en escena")
	update_label()  # Se ejecuta cuando la escena ya está lista

func update_label():
	await get_tree().process_frame  # Espera un frame para asegurar que todo está cargado
	if has_node("HighScore"):  # Aseguramos que el nodo existe
		print("✅ Nodo HighScore encontrado, actualizando texto...", time_elapsed)
		$HighScore.text = "Tiempo jugado: " + str(time_elapsed) + " segundos"
	else:
		print("❌ ERROR: No se encontró el nodo HighScore. Se actualizará más tarde si es necesario.")

func _on_pressed_jugar() -> void:
	get_tree().change_scene_to_file("res://mapa/nivel1/nivel1.tscn") # Replace with function body.


func _on_boton_salir_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://paneles/panel_menuprincipal/menu_principal.tscn")# Replace with function body.
