extends Node

var music_player: AudioStreamPlayer

# List of scenes where music should play
var allowed_scenes = [
	"res://scene/UI/main_menu.tscn",
	"res://scene/levels/levelSCREEN.tscn",
	"res://scene/levels/level1.tscn",
	"res://scene/levels/level2.tscn",
	"res://scene/levels/level3.tscn",
	"res://scene/levels/level4.tscn",
	"res://scene/levels/level5.tscn",
	"res://scene/levels/level6.tscn",
	"res://scene/levels/level7.tscn"
]

func _ready() -> void:
	# Ensure the music persists across scenes
	set_process(true)

	# Create music player only once
	if music_player == null:
		music_player = AudioStreamPlayer.new()
		add_child(music_player)
		music_player.bus = "Music"
		music_player.stream = preload("res://resource/Sounds/music/just-relax-11157.mp3")
		music_player.volume_db = -5

	# Try to play if the current scene is valid
	call_deferred("_on_scene_changed")

func _process(delta: float) -> void:
	_on_scene_changed()

func _on_scene_changed():
	await get_tree().process_frame  # Ensure scene is fully loaded

	var current_scene = get_tree().current_scene
	if current_scene == null:
		return

	var scene_path = current_scene.scene_file_path

	# Check if the music should play
	if scene_path in allowed_scenes:
		if not music_player.playing:
			music_player.play()
	else:
		if music_player.playing:
			music_player.stop()
