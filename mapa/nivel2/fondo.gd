extends StaticBody2D

@onready var player = $"../Pepe"  # Ajusta la ruta si es necesario
@onready var colision_izq = get_node("CollisionShape2D(Izquierda)")
@onready var colision_der = get_node("CollisionShape2D(Derecha)")  # Asegúrate de que tienes un CollisionShape2D

var last_player_y: float

func _ready() -> void:
	last_player_y = player.position.y  # Guarda la posición inicial del jugador

func _process(delta: float) -> void:
	if player.position.y < last_player_y:  # Si el jugador sube
		var delta_y = last_player_y - player.position.y
		position.y -= delta_y  # Mueve el fondo con la colisión
		
	last_player_y = player.position.y  # Actualiza la posición previa
