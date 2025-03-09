extends Area2D

@export var next_level: String = "res://nivel2.tscn"  # Ruta del siguiente nivel

func _on_body_entered(body):
	var nivel = get_parent()  # Obtener el nodo Nivel1

	if nivel.has_method("get_final_time"):  # Verificar si tiene la función
		var final_time = nivel.get_final_time()  # Obtener el tiempo final
		print("🏆 Tiempo final obtenido:", final_time)

		# Cargar la escena de victoria
		var victoria_packed = load("res://paneles/panel_victoria/panel_victoria.tscn")

		if victoria_packed:
			var victoria_scene = victoria_packed.instantiate()

			# Verificar si el nodo tiene la función antes de llamarla
			if victoria_scene.has_method("set_time_elapsed"):
				print("✅ Pasando el tiempo al panel de victoria")
				victoria_scene.set_time_elapsed(final_time)  # Pasar el tiempo
			else:
				print("❌ ERROR: panel_victoria.tscn no tiene set_time_elapsed()")

			# Reemplazar la escena manualmente
			var current_scene = get_tree().current_scene  # Obtener la escena actual
			get_tree().root.add_child(victoria_scene)  # Agregar la escena al árbol
			get_tree().current_scene = victoria_scene  # Definirla como la actual
			current_scene.queue_free()  # Eliminar la anterior
		else:
			print("❌ ERROR: No se pudo cargar la escena de victoria.")
