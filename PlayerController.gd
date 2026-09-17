extends Node3D

@export var mouse_sensitivity: float = 0.003
@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		shoot()

func shoot() -> void:
	# Trigger client-side audio/recoil animation
	$MuzzleSound.play()
	
	if raycast.is_colliding():
		var hit_collider = raycast.get_collider()
		if hit_collider and hit_collider.has_method("register_shot"):
			var shooter_id = multiplayer.get_unique_id()
			hit_collider.register_shot(shooter_id)
