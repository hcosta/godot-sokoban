extends GridObject

# Notas:
# - Este script maneja las cajas en un juego estilo Sokoban.
#   para prevenir que las cajas se muevan a través de otros objetos o fuera de los límites.

@onready var _ray_cast = $RayCast2D

func _enter_tree() -> void: # se ejecuta antes que _ready, es necesaria para hacerlo dinamico
	add_to_group("boxes")
	
func _ready() -> void:
	# - Se asume que el Raycast2D está configurado para detectar Cuerpos y Areas
	_ray_cast.set_collide_with_areas(true)

func pushed(direction : Vector2) -> bool:
	# Intenta empujar la caja en la dirección dada.
	# Retorna true si la caja se mueve, false si encuentra una colisión y no puede moverse.
	if check_collision(direction):
		# Si hay una colisión en la dirección del empuje, no mueve la caja.
		return false
	# Si no hay colisión, mueve la caja y retorna true.
	move(direction)
	return true

func move(direction : Vector2):
	# Realiza el movimiento de la caja en la dirección especificada.
	# Usa un tween para un movimiento suave, dando una sensación más natural y animada.
	var tween = create_tween()
	tween.tween_property(
		self, "position", position + (direction * Globals.GRID_SIZE), Globals.ANIMATION_SPEED
	).set_trans(Tween.TRANS_SINE)
	# Nota: Podrías considerar añadir una señal o callback al completar el tween si necesitas realizar alguna acción post-movimiento.


## Esto se puede heredar de una clase comun
#func move(direction : Vector2) -> void:
	#self.position += direction * Globals.GRID_SIZE
	#
#func check_collision(direction : Vector2) -> bool:
	## Trazamos un rayo para detectar una colisión y mover la caja
	#$RayCast2D.set_target_position(direction * Globals.GRID_SIZE)
	#$RayCast2D.force_raycast_update()
	#return $RayCast2D.is_colliding()
