extends Node

var time_elapsed: int 

func set_time_elapsed(time: int):
	print("✅ Tiempo recibido en panel de victoria:", time)
	time_elapsed = time  # Guardamos el tiempo recibido
	print("", time_elapsed)
	call_deferred("update_label")  # Asegura que se ejecuta cuando todo esté listo

func _ready() -> void:
	print("🏁 Panel de victoria cargado en escena")
	update_label()  # Se ejecuta cuando la escena ya está lista

func update_label():
	if has_node("Segundos"):  # Verificamos si el nodo Segundos existe
		print("✅ Nodo Segundos encontrado, actualizando texto...", time_elapsed)
		$Segundos.text = "Has completado el nivel en: " + str(time_elapsed) + " segundos"
	else:
		print("❌ ERROR: No se encontró el nodo Segundos. Se actualizará más tarde si es necesario.")
		
# Funciones para cambiar de escena
func _on_boton_jugar_de_nuevo_pressed() -> void:
	get_tree().change_scene_to_file("res://mapa/nivel1/nivel1.tscn") 

func _on_pressed_menu() -> void:
	get_tree().change_scene_to_file("res://paneles/panel_menuprincipal/menu_principal.tscn") 
