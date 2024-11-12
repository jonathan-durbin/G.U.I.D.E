const REMAPPING_CONFIG_PATH = "user://remapping_config.tres"

## Loads the saved remapping config if it exists, or an empty remapping
## config if none exists.
static func load_remapping_config() -> GUIDERemappingConfig:
	if ResourceLoader.exists(REMAPPING_CONFIG_PATH):
		return ResourceLoader.load(REMAPPING_CONFIG_PATH)
	else:
		return GUIDERemappingConfig.new()

## Saves the given remapping config to the user folder
static func save_remapping_config(config:GUIDERemappingConfig) -> void:
	ResourceSaver.save(config, REMAPPING_CONFIG_PATH, ResourceSaver.FLAG_CHANGE_PATH)
