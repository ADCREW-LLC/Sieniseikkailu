extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

const TEXTURE_DIRS := [
	"res://arts/rocks",
	"res://arts/bushs",
	"res://arts/trees"
]

# Static (shared) cache of textures
static var ROCK_TEXTURES: Array[Texture2D] = []

# Only load once (the first time)
static func load_textures_once():
	if not ROCK_TEXTURES.is_empty():
		return  # already loaded

	var textures: Array[Texture2D] = []
	for dir_path in TEXTURE_DIRS:
		var dir := DirAccess.open(dir_path)
		if dir == null:
			push_warning("Cannot open directory: %s" % dir_path)
			continue

		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.ends_with(".png") or file_name.ends_with(".webp") or file_name.ends_with(".jpg"):
					var full_path = dir_path.path_join(file_name)
					var tex: Texture2D = load(full_path)
					if tex:
						textures.append(tex)
			file_name = dir.get_next()
		dir.list_dir_end()

	ROCK_TEXTURES = textures
	print("Loaded %d static textures" % ROCK_TEXTURES.size())

func _ready():
	# Load textures only the first time
	load_textures_once()

	# Skip if textures failed to load
	if ROCK_TEXTURES.is_empty():
		return

	# Pick a random texture and scale
	sprite.texture = ROCK_TEXTURES.pick_random()
	sprite.scale = Vector2(randf_range(0.6, 1.0), randf_range(0.6, 1.0))
