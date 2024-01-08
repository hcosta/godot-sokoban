extends GridObject

# Notas importantes:
# - Asegúrate de desactivar la corrección de borde alfa en la Textura2D y reimportar para precisión gráfica.
# - La animación está a 2x para completar el ciclo antes del movimiento.

# Inicialización de nodos necesarios y variables.
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _ray_cast = $RayCast2D

var moving : bool = false  # Controla si el objeto está actualmente en movimiento.

# Diccionario que asocia cada acción de movimiento con su dirección y animación correspondiente.
var movements = {
	"move_left": {"dir": Vector2.LEFT, "anim": "left"},
	"move_right": {"dir": Vector2.RIGHT, "anim": "right"},
	"move_up": {"dir": Vector2.UP, "anim": "up"},
	"move_down": {"dir": Vector2.DOWN, "anim": "down"}
}

func _ready() -> void:
	# El Raycast2D está configurado para detectar Cuerpos y Areas.
	_ray_cast.set_collide_with_areas(true)

func _physics_process(_delta):
	# Si el objeto está en movimiento, no acepta más input para evitar solapamientos o movimientos erráticos.
	if moving: return

	# Obtiene la dirección del input del usuario y procede a intentar mover el objeto.
	var movement_info = get_input_direction()
	try_to_move(movement_info)

func get_input_direction() -> Dictionary:
	# Itera sobre las acciones de movimiento y devuelve la dirección y animación si alguna acción está siendo presionada.
	for action in movements:
		if Input.is_action_pressed(action):
			return {"dir": movements[action]["dir"], "anim": movements[action]["anim"]}
	# Si no hay acciones de movimiento detectadas, devuelve vectores y cadenas vacías.
	return {"dir": Vector2.ZERO, "anim": ""}

func try_to_move(movement_info: Dictionary):
	# Extrae la dirección del movimiento del diccionario de información.
	var direction = movement_info["dir"]
	# Si no hay dirección (es decir, Vector2.ZERO), no intenta mover.
	if direction == Vector2.ZERO: return

	# Verifica colisiones en la dirección deseada antes de mover.
	if check_collision(direction):
		var collider = _ray_cast.get_collider()
		# Si el objeto colisionado puede ser empujado y es exitoso al empujar, mueve al jugador.
		# Esto es típico para cajas en juegos estilo Sokoban.
		if collider and collider.has_method("pushed"):
			if collider.pushed(direction):
				move(direction, movement_info["anim"])
	else:
		# Si no hay colisiones en la dirección, simplemente mueve al jugador.
		move(direction, movement_info["anim"])

func move(direction: Vector2, anim_name: String) -> void:
	# Reproduce la animación de movimiento correspondiente.
	_animated_sprite.play("move_" + anim_name)
	# Crea un tween para animar el movimiento suave del objeto a la nueva posición.
	var tween = create_tween()
	tween.tween_property(
		self, "position", position + (direction * Globals.GRID_SIZE), Globals.ANIMATION_SPEED
	).set_trans(Tween.TRANS_SINE)
	# Marca que el objeto está en movimiento para evitar nuevos inputs hasta que termine.
	moving = true
	await tween.finished  # Espera hasta que el tween de movimiento termine.
	moving = false  # Una vez terminado el tween, permite nuevos movimientos.
	_animated_sprite.stop()  # Detiene la animación de movimiento.

""" V1: Sin diccionarios
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _ray_cast = $RayCast2D
var moving : bool = false

func _physics_process(_delta):
	if moving: return

	var direction : Vector2 = get_input_direction()
	if direction == Vector2.ZERO: return
	try_to_move(direction)

func get_input_direction() -> Vector2:
	if Input.is_action_pressed("move_left"): return Vector2.LEFT
	if Input.is_action_pressed("move_right"): return Vector2.RIGHT
	if Input.is_action_pressed("move_up"): return Vector2.UP
	if Input.is_action_pressed("move_down"): return Vector2.DOWN
	return Vector2.ZERO

func direction_to_string(direction: Vector2) -> String:
	if direction == Vector2.LEFT: return "left"
	if direction == Vector2.RIGHT: return "right"
	if direction == Vector2.UP: return "up"
	if direction == Vector2.DOWN: return "down"
	return ""

func try_to_move(direction: Vector2):
	if check_collision(direction):
		var collider = _ray_cast.get_collider()
		if collider and collider.has_method("pushed"):
			if collider.pushed(direction):
				move(direction)
	else:
		move(direction)

func move(direction : Vector2) -> void:
	_animated_sprite.play("move_" + direction_to_string(direction))
	var tween = create_tween()
	tween.tween_property(
		self, "position", position + (direction * Globals.GRID_SIZE), Globals.ANIMATION_SPEED
	).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false
	_animated_sprite.stop()
 """

### Esto se puede heredar de una clase comun
#func move(direction : Vector2):
	#self.position += direction * Globals.GRID_SIZE
#
#func check_collision(direction : Vector2) -> bool:
	## Trazamos un rayo para detectar una colisión y mover la caja
	#$RayCast2D.set_target_position(direction * Globals.GRID_SIZE)
	#$RayCast2D.force_raycast_update()
	#return $RayCast2D.is_colliding()
