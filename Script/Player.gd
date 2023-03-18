extends CharacterBody3D

# physics
var gravity: float = 12.0
var moveSpeed: float = 5.0
var jumpForce: float = 2.0

# camera
var minLookAngle: float = -90.0
var maxLookAngle: float = 90.0
var lookSensitivity: float = 10.0
var mouseDelta: Vector2 = Vector2()

# objects
@onready var camera: Camera3D = $camera
@onready var sprite: AnimatedSprite3D = $mf_sprite
@onready var sound: AudioStreamPlayer3D = $mf_sound
@onready var marker1 = $marker1
@onready var marker2 = $marker2
@onready var bullets = get_node("../Bullets")
@onready var screen: Screen = $Screen
const BULLET_SCENE = preload("res://Scene/Bullet.tscn")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventKey:
		if event.is_action("close"):
			get_tree().quit()
		
	if event is InputEventMouseButton:
		if event.is_action_pressed("shoot"):
			shoot()
		
	if event is InputEventMouseMotion:
		mouseDelta = event.relative


func _physics_process(delta):
	velocity.x = 0
	velocity.z = 0
	
	var input = Vector3(0, 0, 0)
	if Input.is_action_pressed("move_forward"):
		input.y = -1
	if Input.is_action_pressed("move_backward"):
		input.y = 1
	if Input.is_action_pressed("move_left"):
		input.x = -1
	if Input.is_action_pressed("move_right"):
		input.x = 1
	if Input.is_action_pressed("jump"):
		velocity.y = jumpForce
		
	input = input.normalized()
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	var dir = (forward * input.y + right * input.x)
	
	velocity.x = dir.x * moveSpeed
	velocity.z = dir.z * moveSpeed
	velocity.y -= gravity * delta
	
	move_and_slide()


func _process(delta):
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	self.rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	self.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	
	mouseDelta = Vector2()


func _on_muzzle_flash_animation_looped():
	sprite.stop()
	sprite.frame = 0


func shoot():
	sprite.play("shoot")
	sound.play()
	
	var bullet = BULLET_SCENE.instantiate()
	bullet.position = marker1.global_position
	bullet.set_direction(marker2.global_position - marker1.global_position)
	bullets.add_child(bullet)
	
	screen.increment_count()
