extends Node2D

@export var speed: float = 5000.0  # Velocidad de movimiento de las manos
@onready var mano_izq = $"IK targets/ManoIZQ_target"
@onready var mano_der = $"IK targets/ManoDER_target"
var tween_izq: Tween
var tween_der: Tween

func _ready():
	# Verificar si los nodos existen
	if not mano_izq:
		print("Error: No se encontró ManoIZQ_target")
	if not mano_der:
		print("Error: No se encontró ManoDER_target")

	# Crear tweens después de que el nodo esté listo
	tween_izq = create_tween()
	tween_der = create_tween()

func _process(delta):
	var move_izq = Vector2.ZERO
	var move_der = Vector2.ZERO

	# Controles para la mano izquierda (WASD)
	if Input.is_action_pressed("move_up_izq"):
		move_izq.y -= 1
	if Input.is_action_pressed("move_down_izq"):
		move_izq.y += 1
	if Input.is_action_pressed("move_left_izq"):
		move_izq.x -= 1
	if Input.is_action_pressed("move_right_izq"):
		move_izq.x += 1

	# Controles para la mano derecha (Flechas)
	if Input.is_action_pressed("move_right_der"):
		move_der.x += 1
	if Input.is_action_pressed("move_left_der"):
		move_der.x -= 1
	if Input.is_action_pressed("move_up_der"):
		move_der.y -= 1
	if Input.is_action_pressed("move_down_der"):
		move_der.y += 1

	# Normalizar para evitar movimientos más rápidos en diagonal
	if move_izq.length() > 0:
		move_izq = move_izq.normalized() * speed * delta
	if move_der.length() > 0:
		move_der = move_der.normalized() * speed * delta

	# Detener y recrear los tweens antes de asignar nuevas animaciones
	if tween_izq.is_running():
		tween_izq.kill()
	tween_izq = create_tween()

	if tween_der.is_running():
		tween_der.kill()
	tween_der = create_tween()

	# Aplicar interpolación con Tween
	tween_izq.tween_property(mano_izq, "position", mano_izq.position + move_izq, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween_der.tween_property(mano_der, "position", mano_der.position + move_der, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
