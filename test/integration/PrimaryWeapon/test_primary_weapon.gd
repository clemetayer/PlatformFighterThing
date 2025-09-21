extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var scene

##### SETUP #####
func before_each():
	scene = load("res://test/integration/PrimaryWeapon/primary_weapon_scene.tscn").instantiate()
	add_child_autofree(scene)
	await wait_process_frames(1)

##### TESTS #####
func test_revolver():
	# given
	var revolver = load("res://Scenes/Weapons/Primary/Revolver/revolver.tscn").instantiate()
	revolver.active = true
	scene.spawn_weapon(revolver)
	await wait_for_signal(revolver.tree_entered, 0.25)
	# when / then
	## Checks shoot
	revolver.fire()
	await wait_seconds(0.1)
	assert_eq(scene.get_projectiles().size(),1)
	## Checks cannot shoot on cooldown
	revolver.fire()
	await wait_seconds(0.1)
	assert_eq(scene.get_projectiles().size(),1)
	## Checks can shoot again after cooldown
	await wait_seconds(0.5)
	revolver.fire()
	await wait_seconds(0.1)
	assert_eq(scene.get_projectiles().size(),2)
	# cleanup
	scene.clean_projectiles()
	await wait_seconds(0.1)
