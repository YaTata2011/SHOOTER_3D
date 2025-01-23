extends RigidBody3D

var speed = 20

const time_disapear = 2

var timer = 0
@onready var particles = load("res://sparks_shot.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(transform.basis * Vector3(0, 0, -speed))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#position += transform.basis * Vector3(0, 0, speed * delta)
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			body.damage()
		var sparks = particles.instantiate()
		sparks.position = global_position
		get_tree().get_root().add_child(sparks)
		queue_free()
	
	if timer >= time_disapear:
		queue_free()
	
	timer += delta
