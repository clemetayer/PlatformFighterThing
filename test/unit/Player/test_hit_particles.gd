extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var particles

##### SETUP #####
func before_each():
	particles = load("res://Scenes/Player/hit_particles.tscn").instantiate()
	add_child_autofree(particles)

##### TESTS #####
func test_init():
	# given
	# when
	particles.init(Color.BEIGE)
	# then
	assert_eq(particles.process_material.color, Color.BEIGE)

var hit_params := [
	[Vector2.RIGHT * 100.0, 1.0],
	[Vector2.ONE * 4000.0, 3.0],
	[Vector2.UP * 12000.0, 7.0]
]
func test_hit(params = use_parameters(hit_params)):
	# given
	var pushback_velocity = params[0]
	var expected_multiplier = params[1]
	# when
	particles.hit(pushback_velocity)
	# then
	assert_true(particles.emitting)
	var material = particles.process_material
	assert_eq(material.direction, Vector3(pushback_velocity.x, pushback_velocity.y, 0.0).normalized())
	assert_eq(material.initial_velocity_min, particles.VELOCITY_RANGE[0] * expected_multiplier)
	assert_eq(material.initial_velocity_max, particles.VELOCITY_RANGE[1] * expected_multiplier)

# _get_multiplier pretty much tested in test_hit