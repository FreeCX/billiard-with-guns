extends RigidBody3D
class_name Bullet

var speed: float = 100.0


func set_direction(dir: Vector3):
	apply_impulse(dir * speed)
