extends Node
class_name  Building

var placeable_col = preload("res://Scenes/placeable_mat.tres")
var nonplaceable_col = preload("res://Scenes/nonplaceable_mat.tres")
@export var placement_mode: bool
@export var building_mesh: MeshInstance3D
@export var is_colliding: bool
@export var building_stages = {}
@export var building_progress: int
@export var building_progress_required: int

# Called when the node enters the scene tree for the first time.
func _ready():
	if placement_mode:
		building_mesh.set_surface_override_material(0, placeable_col)

func _on_object_body_entered(body):
	print(body)
	if body.name != "Ground" and placement_mode:
		building_mesh.set_surface_override_material(0, nonplaceable_col)
		is_colliding = true


func _on_object_body_exited(body):
	print(body)
	if placement_mode:
		building_mesh.set_surface_override_material(0, placeable_col)
		is_colliding = false


func place_building():
	var glb_scene = building_stages.get(0)
	var inst = glb_scene.instantiate()
	var mesh = inst.get_child(0).mesh
	building_mesh.mesh = mesh
	building_mesh.set_surface_override_material(0, null)
	placement_mode = false
	$CollisionShape3D2.disabled = false


func mouse_over_entered():
	$SM_House_04.transparency = 0.2


func mouse_over_exited():
	$SM_House_04.transparency = 0
