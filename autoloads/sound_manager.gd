extends Node

var muted: bool = false
var brick_destroyed_sound = preload("res://art/soundreality-pop-reverb-423718.mp3")
var game_over = preload("res://art/02. Battlezone Game Over.mp3")
var background_music_L1 = preload("res://art/09. Level 4.Snd.mp3")
var background_musicL2 = preload("res://art/07. Level 2.Snd.mp3")
var background_musicL3 = preload("res://art/Loop 07.snd.mp3")
var background_musicL4 = preload("res://art/06. Level 1.Snd.mp3")
var level_complete_track = preload("res://art/game_win.mp3")
var background_music: Dictionary
var background_music_player

var background_music_playing: bool = false
var explosion: bool 
const pool_size = 6
var available_players: Array
var players_in_use: Array

#===================================================================================================
#LIFECYCLE FUNCTIONS
#===================================================================================================
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#--- Add Background Music Library to Dictionary ---
	background_music = {
		1:  background_music_L1, 
		2: background_musicL2,
		3: background_musicL3,
		4: background_musicL4, 
		5: background_musicL4,
		6: background_musicL3,
	}
	SoundManager.initialize_music_players()
	SoundManager.initialize_music_players()
	SignalBus.launch_game.connect(_on_launch_game)
	SignalBus.level_complete.connect(_on_level_complete)
	SignalBus.brick_destroyed.connect(func(value, collider): _on_brick_destroyed())
	SignalBus.game_over.connect(_on_game_over)
	SignalBus.muted.connect(_on_muted)


#===================================================================================================
#Signal Handlers
#===================================================================================================
func _on_level_complete():
	stop_background_music()
	background_music_playing = false
	var track = level_complete_track
	var player = play_sound(track)
	player.finished.connect(_on_track_finished)

func _on_launch_game():
	play_background_music(DataConfig.current_level)
	
func _on_brick_destroyed():
	brick_destroyed()

func _on_game_over():
	var track = game_over
	stop_background_music()
	background_music_playing = false
	var player = play_sound(game_over)
	player.finished.connect(_on_track_finished)

func _on_track_finished():
	play_background_music(DataConfig.current_level)
	
	
#===================================================================================================
#Setup Functions
#===================================================================================================

func initialize_music_players():
	#--- Instantiate music players ----
	for i in pool_size:
		create_new_player()

func check_available_players():
	return len(available_players) <= 0
	
func create_new_player():
	var player = AudioStreamPlayer.new()
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(player)
	available_players.append(player)

func fetch_player():
	return available_players.pop_back()
		
#===================================================================================================
#Music Players
#===================================================================================================
func _on_muted():
	muted = not muted
	if muted:
		stop_background_music()
	else: 
		play_background_music(DataConfig.current_level)

func play_background_music(game_level):
	if not background_music_playing and not muted:
		background_music_playing = true
		if game_level > background_music.size():
			game_level = game_level%background_music.size()
		var track = background_music[game_level]
		background_music_player = play_sound(track) 

func brick_destroyed():
	var track = brick_destroyed_sound
	var player_used = play_sound(track)
	await get_tree().create_timer(1).timeout
	if player_used:
		player_used.stop()
		players_in_use.pop_back()
		available_players.append(player_used)

func stop_background_music():
	print("stopping bg music")
	background_music_playing = false
	background_music_player.stop()


func play_sound(track):	
	var idle_players = check_available_players()
	if not idle_players:
		create_new_player()
	var assigned_player = fetch_player()
	players_in_use.append(assigned_player)
	assigned_player.stream = track
	assigned_player.play()
	return assigned_player

	
func stop_playing():
	if len(players_in_use) > 0:
		for player in players_in_use:
			if is_instance_valid(player):
				player.queue_free()
	available_players.clear()
	players_in_use.clear()



#===================================================================================================
#Helper Functions
#===================================================================================================

func generate_random_number() -> int:
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(0,3)
	return random_number
