extends Node3D

enum command_mode_options { PLACING , COMMANDING, NONE }


var _hotbar_1: PackedScene = preload("res://Scenes/house.tscn")
var _hotbar_2: PackedScene = preload("res://Scenes/monument.tscn")

var _command_mode = command_mode_options.NONE
var _mouse_collission_pos
var _mouse_colliding_obj

var _selected_worker
var _currentlyPlacedBuilding

@export var view_camera:Camera3D # Used for raycasting mouse

func _input(event):
	_get_mouse_collission(event)
	
	match _command_mode:
		command_mode_options.NONE:
			_handle_command_mode_none(event)
		command_mode_options.PLACING:
			_handle_command_mode_placing(event)
		command_mode_options.COMMANDING:
			_handle_command_mode_commanding(event)


func _handle_command_mode_none(event):
	var _mouse_collission_pos_collider
	if _mouse_collission_pos.has("collider"):
		_mouse_collission_pos_collider = _mouse_collission_pos.collider

	if event.is_action_pressed("hotbar_1"):
		_currentlyPlacedBuilding = _add_placed_building(_mouse_collission_pos, "hotbar_1")
	elif event.is_action_pressed("hotbar_2"):
		_currentlyPlacedBuilding = _add_placed_building(_mouse_collission_pos, "hotbar_2")
	elif _mouse_collission_pos_collider.is_in_group("Worker") and event.is_action_pressed("left_mouse_button"):
		_command_mode = command_mode_options.COMMANDING
		_selected_worker = _mouse_collission_pos_collider
		_selected_worker.is_selected = true


func _handle_command_mode_placing(event):
	if event.is_action_pressed("left_mouse_button"):
		_place_building(_mouse_collission_pos)
	elif event.is_action_pressed("cancel"):
		get_child(0).queue_free()
		_command_mode = command_mode_options.NONE
	else:
		get_child(0).position = _mouse_collission_pos.position
		get_child(0).position.y = 0


func _handle_command_mode_commanding(event):
	if event.is_action_pressed("cancel"):
		_command_mode = command_mode_options.NONE
		_selected_worker.is_selected = false
	elif event.is_action_pressed("right_mouse_button"):
		if _selected_worker:
			_selected_worker.navigate_to(_mouse_collission_pos.position)


func _get_mouse_collission(event):
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var rayOrigin: Vector3
	var rayEnd: Vector3
	rayOrigin = view_camera.project_ray_origin(mouse_pos)
	rayEnd = rayOrigin + view_camera.project_ray_normal(mouse_pos) * 1000
	
	var ray_param: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	_mouse_collission_pos = space_state.intersect_ray(ray_param)
	
	if _mouse_collission_pos.has("collider"):
		var _mouse_colliding_obj = _mouse_collission_pos.collider


func _add_placed_building(mouse_pos_3d: Variant, hotbar: String = "") -> Variant:
	if get_child_count() > 0:
		get_child(0).queue_free()
	var currentlyPlacedBuilding 
	match hotbar:
		"hotbar_1":
			currentlyPlacedBuilding = _hotbar_1.instantiate()
		"hotbar_2":
			currentlyPlacedBuilding = _hotbar_2.instantiate()

	currentlyPlacedBuilding.position = mouse_pos_3d.position
	currentlyPlacedBuilding.position.y = 0
	currentlyPlacedBuilding.placement_mode = true
	add_child(currentlyPlacedBuilding)
	_command_mode = command_mode_options.PLACING
	return currentlyPlacedBuilding


func _place_building(mouse_pos_3d: Variant):
	var child_tmp = get_child(0)
	if not child_tmp.is_colliding:
		child_tmp.place_building()
		remove_child(child_tmp)
		$"../NavigationRegion3D/Buildings".add_child(child_tmp)
		child_tmp.placement_mode = false
		child_tmp.position = mouse_pos_3d.position
		child_tmp.position.y = 0
		_command_mode = command_mode_options.NONE
		$"../NavigationRegion3D".update_navigation_mesh()
		_command_mode = command_mode_options.NONE
