extends Node3D

signal target_hit(shooter_id, target_distance)

@export var distance: int = 100
@export var exposure_time: float = 3.5

var is_up: bool = false
var is_hit: bool = false

@onready var pivot: Node3D = $PivotPoint

func pop_up() -> void:
	if is_up: return
	is_up = true
	is_hit = false
	
	# Animate pivoting up to 0 degrees (Upright position)
	var tween = create_tween()
	tween.tween_property(pivot, "rotation_degrees:x", 0.0, 0.12)
	
	# Countdown timer to auto-drop if missed
	get_tree().create_timer(exposure_time).timeout.connect(_on_timeout)

func register_shot(shooter_id: int) -> void:
	if not is_up or is_hit: return
	is_hit = true
	is_up = false
	
	# Animate pivoting down flat (-90 degrees)
	var tween = create_tween()
	tween.tween_property(pivot, "rotation_degrees:x", -90.0, 0.08)
	
	emit_signal("target_hit", shooter_id, distance)

func _on_timeout() -> void:
	if is_up and not is_hit:
		is_up = false
		var tween = create_tween()
		tween.tween_property(pivot, "rotation_degrees:x", -90.0, 0.15)
