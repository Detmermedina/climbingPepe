extends Area2D

@export var game_over_scene: String = "res://paneles/panel_gameover/game_over_menu.tscn"  # Ruta de la pantalla de Game Over

var has_moved = false  # Se vuelve "true" cuando el personaje ha saltado o escalado

func _ready():
	await get_tree().create_timer(1.0).timeout  # Evita que el Game Over ocurra instantáneamente al inicio

# Detectar colisión con el suelo
func _on_body_entered(body):
	if has_moved:  # Solo activar si el jugador ya se ha movido
		get_tree().change_scene_to_file(game_over_scene)

# Detectar si el personaje ha saltado o escalado
func _process(delta):
	var bodies = get_overlapping_bodies()  # Verificar si hay cuerpos en el área
	for body in bodies:
		if body is CharacterBody2D:  # Verifica si es un personaje (sin usar grupos)
			if body.velocity.length() > 10:  # Si el personaje está en movimiento
				has_moved = true  # Marcamos que ya se ha movido
