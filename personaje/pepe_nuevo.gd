extends Node2D

# Referencias a las texturas de los antebrazos
@onready var antebrazo_der = $container/cuerpo/AnteBrazoDer  
@export var textura_normal_der: Texture2D = preload("res://assets/pepe/AnteBrazoDER.png")
@export var textura_agarrando_der: Texture2D = preload("res://assets/pepe/AnteBrazoCerradoDER.png")

@onready var antebrazo_izq = $container/cuerpo/AnteBrazoIzq  
@export var textura_normal_izq: Texture2D = preload("res://assets/pepe/AnteBrazoIZQ.png")
@export var textura_agarrando_izq: Texture2D = preload("res://assets/pepe/AnteBrazoCerradoIZQ.png")

# Parámetros de movimiento
@export var speed: float = 5000.0  
@onready var mano_izq = $"IK targets/ManoIZQ_target"
@onready var mano_der = $"IK targets/ManoDER_target"
@onready var cuerpo = $"container/cuerpo"  # Nodo del cuerpo

# Velocidad de seguimiento del cuerpo
var velocidad_cuerpo = 5.0  

# Variables de Tweens
var tween_izq: Tween
var tween_der: Tween

# Estado de agarre
var agarrado_izq = false
var agarrado_der = false

# Distancia máxima permitida entre el hombro y el target
const MAX_DISTANCIA = 43.0  

# Referencia al TileMap
@onready var tilemap = get_node("/root/Nivel1/Fondo/TileMap2(rocas)")  

func _ready():
	if not mano_izq:
		print("Error: No se encontró ManoIZQ_target")
	if not mano_der:
		print("Error: No se encontró ManoDER_target")
	if not tilemap:
		print("Error: No se encontró el TileMap2(rocas)")

	tween_izq = create_tween()
	tween_der = create_tween()
	crear_indicador(mano_izq)
	crear_indicador(mano_der)

func crear_indicador(target):
	if target:
		var indicador = Sprite2D.new()
		indicador.texture = load("res://icon.svg")  
		indicador.modulate = Color(0, 1, 0)  
		indicador.scale = Vector2(0.2, 0.2)  
		target.add_child(indicador)

func _process(delta):
	# Obtener los nodos de los hombros (se asume que son hijos de "cuerpo")
	var hombro_izq = get_node_or_null("container/cuerpo/huesos/Skeleton2D/HuesoCuerpo/Cuello/HombroIZQ")
	var hombro_der = get_node_or_null("container/cuerpo/huesos/Skeleton2D/HuesoCuerpo/Cuello/HombroDER")

	if not hombro_izq or not hombro_der:
		print("⚠️ Error: No se encontró HombroIZQ o HombroDER en la jerarquía")
		return  

	# ── Clamping de las manos ──
	# Siempre limitar la posición de las manos respecto a sus hombros para que no salgan del área establecida
	var direccion_izq = (mano_izq.global_position - hombro_izq.global_position)
	if direccion_izq.length() > MAX_DISTANCIA:
		mano_izq.global_position = hombro_izq.global_position + direccion_izq.normalized() * MAX_DISTANCIA

	var direccion_der = (mano_der.global_position - hombro_der.global_position)
	if direccion_der.length() > MAX_DISTANCIA:
		mano_der.global_position = hombro_der.global_position + direccion_der.normalized() * MAX_DISTANCIA

	# ── Movimiento del cuerpo ──
	# Cuando se agarra, el cuerpo se interpola hacia la posición promedio de las manos (que ya se mantienen dentro del área permitida)
	if agarrado_izq or agarrado_der:
		var punto_objetivo = (mano_izq.global_position + mano_der.global_position) / 2
		cuerpo.global_position = cuerpo.global_position.lerp(punto_objetivo, velocidad_cuerpo * delta)

		# Actualizar la posición de los hombros de forma relativa al cuerpo
		if hombro_izq:
			hombro_izq.position = (mano_izq.global_position + Vector2(10, 10)) - cuerpo.global_position
		if hombro_der:
			hombro_der.position = (mano_der.global_position + Vector2(-10, 10)) - cuerpo.global_position
	else:
		# Si no está agarrado, se aplica gravedad
		cuerpo.velocity.y += 500 * delta  # Simula gravedad
		cuerpo.move_and_slide()  # Evita atravesar el suelo

	# ── Inclinación del cuerpo ──
	var inclinacion = mano_der.global_position.y - mano_izq.global_position.y
	cuerpo.rotation = lerp(cuerpo.rotation, inclinacion * 0.01, delta * velocidad_cuerpo)

	# ── Sistema de agarre ──
	if Input.is_action_pressed("agarrar_der") and es_tile_de_agarre(mano_der.global_position):
		agarrado_der = true
	elif Input.is_action_just_released("agarrar_der"):
		agarrado_der = false

	if Input.is_action_pressed("agarrar_izq") and es_tile_de_agarre(mano_izq.global_position):
		agarrado_izq = true
	elif Input.is_action_just_released("agarrar_izq"):
		agarrado_izq = false

	# Actualizar texturas según el estado de agarre
	antebrazo_der.texture = textura_agarrando_der if agarrado_der else textura_normal_der
	antebrazo_izq.texture = textura_agarrando_izq if agarrado_izq else textura_normal_izq

	# ── Movimiento de targets por input ──
	var move_izq = Vector2.ZERO
	var move_der = Vector2.ZERO

	# Aunque se muevan mediante input, se aplicará el clamping de arriba para evitar salir del área
	if not agarrado_izq:
		if Input.is_action_pressed("move_up_izq"):
			move_izq.y -= 1
		if Input.is_action_pressed("move_down_izq"):
			move_izq.y += 1
		if Input.is_action_pressed("move_left_izq"):
			move_izq.x -= 1
		if Input.is_action_pressed("move_right_izq"):
			move_izq.x += 1

	if not agarrado_der:
		if Input.is_action_pressed("move_right_der"):
			move_der.x += 1
		if Input.is_action_pressed("move_left_der"):
			move_der.x -= 1
		if Input.is_action_pressed("move_up_der"):
			move_der.y -= 1
		if Input.is_action_pressed("move_down_der"):
			move_der.y += 1

	if move_izq.length() > 0:
		move_izq = move_izq.normalized() * speed * delta
	if move_der.length() > 0:
		move_der = move_der.normalized() * speed * delta

	if tween_izq and tween_izq.is_running():
		tween_izq.kill()
	tween_izq = create_tween()

	if tween_der and tween_der.is_running():
		tween_der.kill()
	tween_der = create_tween()

	tween_izq.tween_property(mano_izq, "position", mano_izq.position + move_izq, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween_der.tween_property(mano_der, "position", mano_der.position + move_der, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

	queue_redraw() 

func _draw():
	if mano_izq:
		draw_circle(mano_izq.position, 10, Color(0, 1, 0))
	if mano_der:
		draw_circle(mano_der.position, 10, Color(0, 1, 0))

func es_tile_de_agarre(posicion_global):
	if not tilemap:
		print("Error: No se encontró el TileMap2(rocas)")
		return false
	
	var tile_pos = tilemap.local_to_map(posicion_global)
	
	for layer in range(tilemap.get_layers_count()):
		var tile_data = tilemap.get_cell_tile_data(layer, tile_pos)
		if tile_data and tile_data.get_custom_data("Agarres") == true:
			return true  

	return false
