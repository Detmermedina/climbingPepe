extends Area2D

@export var game_over_scene: String = "res://paneles/panel_gameover/game_over_menu.tscn"  # Ruta de la pantalla de Game Over

var has_moved = false  # Se vuelve "true" cuando el personaje ha saltado o escalado

func _ready():
	await get_tree().create_timer(1.0).timeout  # Evita que el Game Over ocurra instantáneamente al inicio

# Detectar colisión con el suelo
func _on_body_entered(body):
	if has_moved:  # Solo activar si el jugador ya se ha movido
		var nivel = get_parent()  # Obtener el nodo Nivel1
		if nivel.has_method("get_final_time"):  # Verificar si tiene la función
			var final_time = nivel.get_final_time()  # Obtener el tiempo final
			print("Tiempo final en perder:", final_time)

			# Cargar la escena de victoria
			var derrota_packed = load("res://paneles/panel_gameover/game_over_menu.tscn")

			if derrota_packed:
				var derrota_scene = derrota_packed.instantiate()

				# Verificar si el nodo tiene la función antes de llamarla
				if derrota_scene.has_method("set_time_elapsed"):
					print("✅ Pasando el tiempo al panel de victoria")
					derrota_scene.set_time_elapsed(final_time)  # Pasar el tiempo
				else:
					print("❌ ERROR: game_over_menu.tscn no tiene set_time_elapsed()")

				# Reemplazar la escena manualmente
				var current_scene = get_tree().current_scene  # Obtener la escena actual
				get_tree().root.add_child(derrota_scene)  # Agregar la escena al árbol
				get_tree().current_scene = derrota_scene  # Definirla como la actual
				current_scene.queue_free()  # Eliminar la anterior
			else:
				print("❌ ERROR: No se pudo cargar la escena de game over.")


# Detectar si el personaje ha saltado o escalado
func _process(delta):
	var bodies = get_overlapping_bodies()  # Verificar si hay cuerpos en el área
	for body in bodies:
		if body is CharacterBody2D:  # Verifica si es un personaje (sin usar grupos)
			if body.velocity.length() > 10:  # Si el personaje está en movimiento
				has_moved = true  # Marcamos que ya se ha movido
