extends Camera3D

@export var movement_speed = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_move(delta)

func _move(delta):
	var velocity: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("forward"):
		velocity -= transform.basis.z
	if Input.is_action_pressed("backward"):
		velocity += transform.basis.z
	if Input.is_action_pressed("left"):
		velocity -= transform.basis.x
	if Input.is_action_pressed("right"):
		velocity += transform.basis.x
	global_transform.origin += global_transform.basis.x * velocity.x * movement_speed * delta
	var forward = global_transform.basis.x.cross(Vector3.UP)
	global_transform.origin += forward * velocity.y * movement_speed * delta
