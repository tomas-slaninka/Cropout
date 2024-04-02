extends CharacterBody3D

@export var is_selected: bool
@export var worker_mesh: MeshInstance3D
@onready var agent = $NavigationAgent3D 
var selected_col = preload("res://Scenes/selected.tres")
var nonselected_col = preload("res://Scenes/nonselected.tres")
var SPEED = 6
var targ: Vector3


func _physics_process(delta):
	look_at(targ)
	rotation.x = 0
	rotation.z = 0

	if position.distance_to(targ) > 0.5:
		var curLoc = global_transform.origin
		var nextLoc = agent.get_next_path_position()
		var newVel = (nextLoc - curLoc).normalized() * SPEED 
		velocity = newVel
		move_and_slide()
	handle_color_change()

func handle_color_change():
	if is_selected:
		worker_mesh.set_surface_override_material(0, selected_col)
	else:
		worker_mesh.set_surface_override_material(0, nonselected_col)


func navigate_to(destination):
	targ = destination
	updateTargetLocation(targ)


func updateTargetLocation(target):
	agent.set_target_position(target)
