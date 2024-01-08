extends Area2D  # Extiende de Area2D, una base común para objetos 2D que detectan colisiones.

class_name GridObject  # Esto permite referenciar GridObject directamente en otros scripts.

func _ready() -> void:
	# Al inicio, ajusta la posición del objeto a la cuadrícula definida por GRID_SIZE.
	# Esto asegura que todos los objetos comiencen perfectamente alineados con la cuadrícula.
	position = position.snapped(Globals.GRID_SIZE)
	position -= Globals.GRID_SIZE * 0.5  # Ajusta para que el centro del objeto esté en el centro de la cuadrícula.

# Función que verifica si hay una colisión en la dirección dada.
# Utiliza RayCast2D para proyectar un rayo en la dirección y detectar colisiones.
func check_collision(direction : Vector2) -> bool:
	# Configura el RayCast2D para apuntar en la dirección del movimiento propuesto.
	$RayCast2D.set_target_position(direction * Globals.GRID_SIZE)
	$RayCast2D.force_raycast_update()  # Actualiza el RayCast2D para asegurar que los datos de colisión son recientes.
	return $RayCast2D.is_colliding()  # Retorna true si hay una colisión, false si el camino está libre.

## Esto se puede heredar de una clase comun, pero ya no funciona
## porque la función move del Player requiere pasar mas argumentos
##func move(direction : Vector2):
##	position += direction * Globals.GRID_SIZE
