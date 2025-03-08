extends Node2D

# Referencias a las texturas de los antebrazos
@onready var antebrazo_der = $container/cuerpo/AnteBrazoDer  
@export var textura_normal_der: Texture2D = preload("res://assets/pepe/AnteBrazoDER.png")
@export var textura_agarrando_der: Texture2D = preload("res://assets/pepe/AnteBrazoCerradoDER.png")

@onready var antebrazo_izq = $container/cuerpo/AnteBrazoIzq  
@export var textura_normal_izq: Texture2D = preload("res://assets/pepe/AnteBrazoIZQ.png")
@export var textura_agarrando_izq: Texture2D = preload("res://assets/pepe/AntebrazoCerradoIZQ.png")

# Parámetros de movimiento
@export var speed: float = 5000.0  
@onready var mano_izq = $"IK targets/ManoIZQ_target"
@onready var mano_der = $"IK targets/ManoDER_target"

# Variables de Tweens
var tween_izq: Tween
var tween_der: Tween

# Estado de agarre
var agarrado_izq = false
var agarrado_der = false

# Distancia máxima permitida entre el hombro y el target (ajusta según el tamaño del personaje)
const MAX_DISTANCIA = 43.0  # Ajusta este valor según necesites

# Referencia al TileMap (Asegúrate de que el nombre es correcto en la jerarquía)
@onready var tilemap = get_node("/root/Nivel1/Fondo/TileMap2(rocas)")  # Ajusta si es necesario

func _ready():
	# Verificar si los nodos existen
	if not mano_izq:
		print("Error: No se encontró ManoIZQ_target")
	if not mano_der:
		print("Error: No se encontró ManoDER_target")
	if not tilemap:
		print("Error: No se encontró el TileMap2(rocas)")

	# Crear tweens después de que el nodo esté listo
	tween_izq = create_tween()
	tween_der = create_tween()

	# Crear indicadores visuales para los targets
	crear_indicador(mano_izq)
	crear_indicador(mano_der)

func crear_indicador(target):
	if target:
		var indicador = Sprite2D.new()
		indicador.texture = load("res://icon.svg")  # Usa una textura o círculo
		indicador.modulate = Color(0, 1, 0)  # Verde
		indicador.scale = Vector2(0.2, 0.2)  # Tamaño más pequeño
		target.add_child(indicador)
		
		

func _process(delta):
	# Obtener los nodos de los hombros
	var hombro_izq = get_node_or_null("container/huesos/Skeleton2D/HuesoCuerpo/Cuello/HombroIZQ")
	var hombro_der = get_node_or_null("container/huesos/Skeleton2D/HuesoCuerpo/Cuello/HombroDER")

	# Si alguno de los hombros no existe, salir del proceso para evitar errores
	if not hombro_izq or not hombro_der:
		print("⚠️ Error: No se encontró HombroIZQ o HombroDER en la jerarquía")
		return  

	# Obtener las posiciones de los hombros
	var hombro_izq_pos = hombro_izq.global_position
	var hombro_der_pos = hombro_der.global_position

	# Restricción circular para el target izquierdo
	var direccion_izq = (mano_izq.global_position - hombro_izq_pos)
	if direccion_izq.length() > MAX_DISTANCIA:
		mano_izq.global_position = hombro_izq_pos + direccion_izq.normalized() * MAX_DISTANCIA

# Restricción circular para el target derecho
	var direccion_der = (mano_der.global_position - hombro_der_pos)
	if direccion_der.length() > MAX_DISTANCIA:
		mano_der.global_position = hombro_der_pos + direccion_der.normalized() * MAX_DISTANCIA
	
	
	# Detectar cuando se presiona la acción "agarrar_der" o "agarrar_izq"
	if Input.is_action_pressed("agarrar_der") and es_tile_de_agarre(mano_der.global_position):
		agarrado_der = true
	elif Input.is_action_just_released("agarrar_der"):
		agarrado_der = false
	
	if Input.is_action_pressed("agarrar_izq") and es_tile_de_agarre(mano_izq.global_position):
		agarrado_izq = true
	elif Input.is_action_just_released("agarrar_izq"):
		agarrado_izq = false

	# Cambiar texturas dependiendo del agarre
	antebrazo_der.texture = textura_agarrando_der if agarrado_der else textura_normal_der
	antebrazo_izq.texture = textura_agarrando_izq if agarrado_izq else textura_normal_izq

	var move_izq = Vector2.ZERO
	var move_der = Vector2.ZERO

	# Movimiento si no está agarrado
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

	# Normalizar para evitar movimientos más rápidos en diagonal
	if move_izq.length() > 0:
		move_izq = move_izq.normalized() * speed * delta
	if move_der.length() > 0:
		move_der = move_der.normalized() * speed * delta

	# Verificar si los tweens existen antes de llamar is_running()
	if tween_izq and tween_izq.is_running():
		tween_izq.kill()
	tween_izq = create_tween()

	if tween_der and tween_der.is_running():
		tween_der.kill()
	tween_der = create_tween()

	# Aplicar interpolación con Tween
	tween_izq.tween_property(mano_izq, "position", mano_izq.position + move_izq, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween_der.tween_property(mano_der, "position", mano_der.position + move_der, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

	queue_redraw()  # Para actualizar el dibujo de los círculos

func _draw():
	# Dibuja un círculo verde en los targets de las manos
	if mano_izq:
		draw_circle(mano_izq.position, 10, Color(0, 1, 0))
	if mano_der:
		draw_circle(mano_der.position, 10, Color(0, 1, 0))

# Función para verificar si un tile es de agarre
func es_tile_de_agarre(posicion_global):
	if not tilemap:
		print("Error: No se encontró el TileMap2(rocas)")
		return false
	
	var tile_pos = tilemap.local_to_map(posicion_global)  # Convertir la posición global a coordenadas del TileMap
	
	# Revisar todas las capas del TileMap en busca del tile de agarre
	for layer in range(tilemap.get_layers_count()):
		var tile_data = tilemap.get_cell_tile_data(layer, tile_pos)
		if tile_data and tile_data.get_custom_data("Agarres") == true:
			return true  # Es un tile de agarre

	return false
