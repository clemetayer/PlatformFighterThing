@tool
extends Node2D
# class_name Class
# Used to split a destructible wall in smaller fragments to make a cool break effect
# USAGE : add this node to your scene, MAKE IT SO THE CHILDREN ARE EDITABLE, add a tilemap_path and click on the _bake_button

##### VARIABLES #####
#---- CONSTANTS -----
const NUMBER_OF_FRAGMENTS := 20
const FRAGMENT_SCENE := preload("res://Scenes/DestructibleWalls/WallFragments/fragment.tscn")
const TRESHOLD := 10.0 # Prevents slim triangles being created at the sprite edges.

#---- EXPORTS -----
@export var tilemap_path : NodePath
# A fake button to bake the wall fragments
@export var bake: bool = false : set = _bake_wall_fragments

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"fragments":$"Fragments",
	"sprite":$"Sprite",
	"reset_timer":$"ResetTimer"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		hide()
		onready_paths.sprite.hide()
		var tilemap = get_node_or_null(tilemap_path)
		if tilemap != null:
			tilemap.connect("explode_fragments", _on_tilemap_explode)

##### PROTECTED METHODS #####
func _bake_wall_fragments(_fake_bool) -> void:
	if Engine.is_editor_hint():
		print("Baking tilemap for the break effect")
		_delete_children()
		_create_sprite()
		_reposition_sprite()
		_create_fragments()
		onready_paths.fragments.position = onready_paths.sprite.position

func _delete_children() -> void:
	for child in onready_paths.fragments.get_children():
		child.queue_free()

func _create_sprite() -> void:
	var tilemap = get_node(tilemap_path)
	var tilemap_dup = tilemap.duplicate()
	var parent = tilemap.get_parent()
	var vp_container = SubViewportContainer.new()
	vp_container.size = tilemap_dup.get_used_rect().size * 64
	var vp = SubViewport.new()
	vp.size = tilemap_dup.get_used_rect().size * 64
	# vp.transparent_bg = true
	vp_container.add_child(vp)
	tilemap_dup.position = -tilemap_dup.get_used_rect().position * 64
	vp.add_child(tilemap_dup)
	parent.add_child(vp_container)
	vp_container.owner = get_tree().edited_scene_root
	vp.owner = get_tree().edited_scene_root
	tilemap_dup.owner = get_tree().edited_scene_root
	await(get_tree().create_timer(0.1).timeout) # wait for a short time to not have an empty image
	var capture = vp.get_texture().get_image()
	onready_paths.sprite.texture = ImageTexture.create_from_image(capture)
	vp_container.queue_free()

func _reposition_sprite() -> void:
	var tilemap = get_node(tilemap_path)
	onready_paths.sprite.position = tilemap.get_used_rect().position * 64

# partly inspired from this post https://www.reddit.com/r/godot/comments/nimkqg/how_to_break_a_2d_sprite_in_a_cool_and_easy_way/
func _create_fragments() -> void:
	if onready_paths.sprite.get_texture() != null:
		var points = [] 
		var triangles = []
		var fragments = []
		var rect = onready_paths.sprite.get_rect()
		# outer frame points
		points.append(rect.position)
		points.append(rect.position + Vector2(rect.size.x, 0))
		points.append(rect.position + Vector2(0, rect.size.y))
		points.append(rect.end)
		for point_idx in NUMBER_OF_FRAGMENTS:
			var point = rect.position + Vector2(randi_range(0, rect.size.x), randi_range(0, rect.size.y))
			# move outer points onto rectangle edges
			if point.x < rect.position.x + TRESHOLD:
				point.x = rect.position.x
			elif point.x > rect.end.x - TRESHOLD:
				point.x = rect.end.x
			if point.y < rect.position.y + TRESHOLD:
				point.y = rect.position.y
			elif point.y > rect.end.y - TRESHOLD:
				point.y = rect.end.y
			points.append(point)
		# calculate triangles
		var delaunay = Geometry2D.triangulate_delaunay(points)
		for i in range(0, delaunay.size(), 3):
			triangles.append([points[delaunay[i + 2]], points[delaunay[i + 1]], points[delaunay[i]]])
		# create RigidBody2D fragments
		var texture = onready_paths.sprite.get_texture()
		for triangle in triangles:
			var center = Vector2((triangle[0].x + triangle[1].x + triangle[2].x)/3.0,(triangle[0].y + triangle[1].y + triangle[2].y)/3.0)

			var fragment = FRAGMENT_SCENE.instantiate()
			fragment.position = center
			fragments.append(fragment)

			#setup polygons & collision shapes
			fragment.get_node("Polygon2D").texture = texture
			fragment.get_node("Polygon2D").polygon = triangle
			fragment.get_node("Polygon2D").position = -center

			#shrink polygon so that the collision shapes don't overlapp
			var shrunk_triangles = Geometry2D.offset_polygon(triangle, -2)
			if shrunk_triangles.size() > 0:
				fragment.get_node("CollisionPolygon2D").polygon = shrunk_triangles[0]
			else:
				fragment.get_node("CollisionPolygon2D").polygon = triangle
			fragment.get_node("CollisionPolygon2D").position = -center
		queue_redraw()
		call_deferred("_add_fragments", fragments)
	else:
		print("Somehow the sprite texture is undefined, unable to create fragments")

func _add_fragments(fragments : Array) -> void:
	for fragment in fragments:
		onready_paths.fragments.add_child(fragment)
		fragment.owner = get_tree().edited_scene_root
		set_editable_instance(fragment,true)

##### SIGNAL MANAGEMENT #####
func _on_tilemap_explode(p_position : Vector2, force : Vector2) -> void:
	show()
	Logger.debug("destroying destructible wall")
	onready_paths.reset_timer.start()
	for fragment in onready_paths.fragments.get_children():
		fragment.explode(p_position, force)

func _on_reset_timer_timeout() -> void:
	hide()
	Logger.debug("resetting destructible wall")
	for fragment in onready_paths.fragments.get_children():
		fragment.reset()
