@tool
extends Node
# Tool editor to automatically generate a resource list from the contents of a folder

##### VARIABLES #####
#---- EXPORTS -----
@export var RESOURCES: Array
@export var GENERATE: bool = false:
	set(value):
		for resource in RESOURCES:
			_generate_resources(resource)


##### PROTECTED METHODS #####
func _generate_resources(config: ResourceListGeneratorConfig) -> void:
	var resource = ResourceList.new()
	var file_paths = []
	for extension in config.EXTENSIONS:
		file_paths.append_array(
			StaticUtils.list_files_in_dir(config.FOLDER) \
				.filter(func(file): return file.ends_with(extension))
				.map(func(file): return "%s%s" % [config.FOLDER, file])
		)
	for file_path in file_paths:
		resource.RESOURCES.append(load(file_path))
	print("saving %s to %s" % [file_paths, config.SAVE_PATH])
	ResourceSaver.save(resource, config.SAVE_PATH)
