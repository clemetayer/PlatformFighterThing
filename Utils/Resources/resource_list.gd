extends Resource
class_name ResourceList
# For the player customization elements, on the exported version, scanning the filesystem at runtime won't work.
# So this resource is made to avoid this issue

@export var RESOURCES := []
