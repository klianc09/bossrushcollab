extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateAudio()
	$VBoxContainer/MusicCheckbox.toggled.connect(onMusicMute)
	$VBoxContainer/SFXCheckbox.toggled.connect(onSfxMute)

func updateAudio():
	$VBoxContainer/MusicCheckbox.button_pressed = not Singleton.musicMuted
	$VBoxContainer/SFXCheckbox.button_pressed = not Singleton.sfxMuted
	var music_bus = AudioServer.get_bus_index("Music")
	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(music_bus, Singleton.musicMuted)
	AudioServer.set_bus_mute(sfx_bus, Singleton.sfxMuted)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_pause"):
		togglePause()

func togglePause():
	visible = not visible
	get_tree().paused = visible

func onMusicMute(toggled):
	Singleton.musicMuted = not Singleton.musicMuted
	updateAudio()

func onSfxMute(toggled):
	Singleton.sfxMuted = not Singleton.sfxMuted
	updateAudio()


func _on_continue_btn_pressed() -> void:
	if visible:
		togglePause()


func _on_restart_btn_pressed() -> void:
	if visible:
		togglePause()
		Singleton.resetScene()
