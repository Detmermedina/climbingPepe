extends CharacterBody2D

var skeleton: Skeleton2D
var modification: SkeletonModification2D

# Nombres de los huesos que se moverán (deben coincidir exactamente con los del editor)
var bone_names = ["HombroIZQ", "CodoIZQ", "HombroDER", "CodoDER"]
var bone_indices = {}  # Aquí se guardarán los índices detectados

# Velocidad de interpolación (cuanto mayor, más rápido se ajustan los ángulos)
var rotation_speed: float = 5.0

# Variables para almacenar los ángulos actuales de cada hueso
var left_shoulder_angle: float = 0.0
var left_elbow_angle: float = 0.0
var right_shoulder_angle: float = 0.0
var right_elbow_angle: float = 0.0

# Variables para almacenar los ángulos objetivo calculados a partir de la entrada
var left_target: float = 0.0
var right_target: float = 0.0

func _ready():
	# Obtener el nodo Skeleton2D (asegúrate de que es hijo directo de este CharacterBody2D)
	skeleton = $Skeleton2D
	if not skeleton:
		push_error("❌ No se encontró el nodo Skeleton2D en " + str(get_path()))
		return

	# Obtener la pila de modificaciones
	var mod_stack = skeleton.get_modification_stack()
	if mod_stack == null:
		push_error("❌ El Skeleton2D no tiene una pila de modificaciones configurada. Agrega un SkeletonModification2D en el Inspector.")
		return

	var modifications = mod_stack.get_modifications()
	if modifications == null or modifications.size() == 0:
		push_error("❌ La pila de modificaciones está vacía. Agrega un SkeletonModification2D en el Inspector.")
		return

	# Tomar la primera modificación (debe ser de tipo SkeletonModification2D)
	modification = modifications[0]
	if not modification is SkeletonModification2D:
		push_error("❌ La modificación no es del tipo SkeletonModification2D.")
		return

	# Habilitar la modificación
	modification.set_enabled(true)
	mod_stack.set_dirty(true)

	# Recorrer los huesos disponibles en la modificación para guardar los índices de los que necesitamos
	for i in range(modification.get_bone_count()):
		var bname = modification.get_bone_name(i)
		print("🔍 Hueso detectado: ", bname)  # Depuración
		if bname in bone_names:
			bone_indices[bname] = i

	print("✅ Huesos encontrados: ", bone_indices)
	if bone_indices.size() < 4:
		push_error("⚠️ No se encontraron todos los huesos necesarios. Revisa que los nombres coincidan en el editor.")

func _process(delta):
	# Si no se han detectado los 4 huesos, salir
	if bone_indices.size() < 4:
		return

	# --- Leer la entrada para el brazo izquierdo (WASD) ---
	var left_input = Vector2(
		Input.get_action_strength("left_arm_right") - Input.get_action_strength("left_arm_left"),
		Input.get_action_strength("left_arm_down") - Input.get_action_strength("left_arm_up")
	)
	# --- Leer la entrada para el brazo derecho (Flechas) ---
	var right_input = Vector2(
		Input.get_action_strength("right_arm_right") - Input.get_action_strength("right_arm_left"),
		Input.get_action_strength("right_arm_down") - Input.get_action_strength("right_arm_up")
	)

	# Si hay entrada significativa, calcular el ángulo objetivo
	if left_input.length() > 0.1:
		left_target = left_input.angle()
	if right_input.length() > 0.1:
		right_target = right_input.angle()

	# Interpolar de forma fluida hacia los ángulos objetivo
	left_shoulder_angle = lerp_angle(left_shoulder_angle, left_target, rotation_speed * delta)
	right_shoulder_angle = lerp_angle(right_shoulder_angle, right_target, rotation_speed * delta)

	# Para el codo (antebrazo), usamos un factor menor para que siga al hombro (por ejemplo, 70% del ángulo)
	left_elbow_angle = lerp_angle(left_elbow_angle, left_target * 0.7, rotation_speed * delta)
	right_elbow_angle = lerp_angle(right_elbow_angle, right_target * 0.7, rotation_speed * delta)

	# Aplicar las rotaciones a los huesos
	modification.set_bone_rotation(bone_indices["HombroIZQ"], left_shoulder_angle)
	modification.set_bone_rotation(bone_indices["CodoIZQ"], left_elbow_angle)
	modification.set_bone_rotation(bone_indices["HombroDER"], right_shoulder_angle)
	modification.set_bone_rotation(bone_indices["CodoDER"], right_elbow_angle)

	# Forzar la actualización de la pila de modificaciones para aplicar los cambios
	skeleton.get_modification_stack().force_update()
