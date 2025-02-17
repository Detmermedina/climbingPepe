extends Camera2D

var velocidad = 50  # Velocidad de movimiento de la cámara

func _process(delta):
	position.y -= velocidad * delta  # Mueve la cámara hacia arriba
