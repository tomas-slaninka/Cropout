extends CharacterBody3D


@onready var agent = $NavigationAgent3D 
var SPEED = 3
var targ: Vector3

var RNG = RandomNumberGenerator.new()

func _ready():
	targ = Vector3(randf_range(-10,10), 0, randf_range(-10,10))
	updateTargetLocation(targ)

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
	else:
		RNG.randomize()
		targ = Vector3(randf_range(-10,10), 0, randf_range(-10,10))
		updateTargetLocation(targ)


func updateTargetLocation(target):
	agent.set_target_position(target)
