extends Node2D

@export var tilemap: TileMap
@export var player: Node2D
@export var tile_id: int = 69  # Asegúrate de que este ID coincida con el índice de tu tile en el TileSet

var generation_step = 100
var last_generated_y = 0
var level_width = 5  # Número de tiles de ancho donde pueden aparecer rocas

func _ready():
	if not tilemap or not player:
		push_error("Error: tilemap o player no asignados en LevelGenerator.")
		return
	randomize()  # Inicializa la semilla de números aleatorios
	last_generated_y = player.global_position.y
	print("LevelGenerator READY. last_generated_y =", last_generated_y)

func _process(delta):
	if not tilemap or not player:
		return

	var player_y = player.global_position.y

	if player_y < last_generated_y - generation_step:
		print("Generando rocas...")
		generate_rocks(player_y)
		last_generated_y = player_y

func generate_rocks(y_position):
	print("Generando rocas en Y =", y_position)
	# Convertir la posición del jugador en coordenadas de celda del TileMap
	var base_tile_coords = tilemap.world_to_map(Vector2(player.global_position.x, y_position))
	
	# Genera 3 rocas en esta iteración
	for i in range(3):
		var random_x_offset = int(randf_range(-level_width, level_width + 1))
		var tile_coords = Vector2(base_tile_coords.x + random_x_offset, base_tile_coords.y - i)
		# Convertir a Vector2i, ya que set_cellv() requiere enteros
		var tile_coords_int = Vector2i(tile_coords.x, tile_coords.y)
		tilemap.set_cellv(tile_coords_int, tile_id)
		print("Roca generada en:", tile_coords_int)
