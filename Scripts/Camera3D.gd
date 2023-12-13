extends Camera3D

@export var movement_speed = 50
var mouse = Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_move(delta)

func _move(delta):
	var velocity: Vector3
	
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

func _input(event):
	if event is InputEventMouse:
		mouse = event.position
	if event is InputEventMouseButton and event.is_pressed():
		get_selection()

func get_selection():
	var worldspace = get_world_3d().direct_space_state
	var start = project_ray_origin(mouse)
	var end = project_position(mouse, 1000)
	var ray_param: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start, end)
	var result = worldspace.intersect_ray(ray_param)
	print(result)
