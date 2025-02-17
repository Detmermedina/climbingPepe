extends TileMap

@export var ancho_mapa := 50   # Ancho del mapa en celdas
@export var altura_mapa := 50  # Altura del mapa en celdas
@export var probabilidad_roca := 0.2  # 20% de probabilidad

func _ready():
	generar_rocas()

func generar_rocas():
	# Ajusta estos valores según tu TileSet:
	var layer_id := 0          # Si usas "Layer1", prueba con 0 o 1
	var roca_id := 0           # ID del Source de la roca
	var atlas_coords := Vector2i(0, 0)  # Coordenada del tile en el atlas
	
	for x in ancho_mapa:
		for y in altura_mapa:
			if randf() < probabilidad_roca:
				set_cell(layer_id, Vector2i(x, y), roca_id, atlas_coords)
