extends Node3D


var hotbar_1: PackedScene = preload("res://Scenes/house.tscn")
var hotbar_2: PackedScene = preload("res://Scenes/monument.tscn")
var is_placing: bool = false

@export var view_camera:Camera3D # Used for raycasting mouse
var plane:Plane # Used for raycasting mouse

var rayOrigin: Vector3
var rayEnd: Vector3

func _ready():
	plane = Plane(Vector3.UP, Vector3.ZERO)

const RAY_LENGTH = 1000.0
func _input(event):
	var currentlyPlacedBuilding
	
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	rayOrigin = view_camera.project_ray_origin(mouse_pos)
	rayEnd = rayOrigin + view_camera.project_ray_normal(mouse_pos) * 10000
	var ray_param: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	
	var intersect = space_state.intersect_ray(ray_param)
	if intersect:
		$House.position = intersect.position
		$House.position.y = 0
	
	
	if event.is_action_pressed("hotbar_1"):
		currentlyPlacedBuilding = hotbar_1.instantiate()
		add_child(currentlyPlacedBuilding)
		currentlyPlacedBuilding
		is_placing = true
	elif event.is_action_pressed("left_mouse_button") and is_placing:
		
		is_placing = false
		
	elif event.is_action_pressed("cancel") and is_placing:
		is_placing = false
		


func _on_house_body_entered(body):
	print(body)
	if body.name != "Ground":
		$House/SM_House_04.set_surface_override_material(0, load("res://Scenes/nonplaceable_mat.tres"))


func _on_house_body_exited(body):
	print(body)
	$House/SM_House_04.set_surface_override_material(0, load("res://Scenes/placeable_mat.tres"))
