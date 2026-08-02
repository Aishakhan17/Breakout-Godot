extends Node
var brick_destroyed_sound = preload("res://art/soundreality-pop-reverb-423718.mp3")
#var explosion = preload("res://art/explosion.wav")
var background_music_L1 = preload("res://art/09. Level 4.Snd.mp3")
var background_musicL2 = preload("res://art/07. Level 2.Snd.mp3")
var background_musicL3 = preload("res://art/08. Level 3.Snd.mp3")
var background_musicL4 = preload("res://art/06. Level 1.Snd.mp3")

var background_music: Dictionary
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
	}
	SignalBus.brick_destroyed.connect(func(value, collider): _on_brick_destroyed)
#===================================================================================================
#Music Handlers
#===================================================================================================

func initialize_music_players():
	#--- Instantiate music players ----
	for i in pool_size:
		create_new_player()

func check_available_players():
	return len(available_players) <= 0
	
func create_new_player():
	var player = AudioStreamPlayer.new()
	add_child(player)
	available_players.append(player)

func fetch_player():
	return available_players.pop_back()

#===================================================================================================
#Music Players
#===================================================================================================

func play_background_music(game_level):
	print("playing music")
	var track = background_music[game_level]
	play_sound(track) 

func _on_brick_destroyed():
	brick_destroyed()
	
func brick_destroyed():
	print('sound manager destroy brick signal called')
	var track = brick_destroyed_sound
	var player_used = play_sound(track)
	await get_tree().create_timer(1).timeout
	if player_used:
		player_used.queue_free()
		players_in_use.pop_back()
	
func play_explosion():
	pass
	

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
