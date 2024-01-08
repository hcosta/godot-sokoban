extends GridObject

# Notas:
# - Este script maneja las áreas objetivo en un juego estilo Sokoban.
# - Es importante que la CollisionShape del área objetivo sea pequeña para evitar activaciones no deseadas por el roce.

signal target_done_changed(is_done)
var done : bool = false  # Estado que indica si el objetivo está completado (una caja está en el lugar correcto).

func _enter_tree() -> void:  # se ejecuta antes que _ready, es necesaria para hacerlo dinamico
	add_to_group("targets")

func _on_area_entered(area: Area2D) -> void:
	# Detecta cuando una caja entra en el área objetivo.
	if area.is_in_group("boxes"):
		done = true  # Actualiza el estado a completado.
		emit_signal("target_done_changed", done)

func _on_area_exited(area: Area2D) -> void:
	# Detecta cuando una caja sale del área objetivo.
	if area.is_in_group("boxes"):
		done = false  # Actualiza el estado a no completado.
		emit_signal("target_done_changed", done)
