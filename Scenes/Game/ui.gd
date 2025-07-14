extends CanvasLayer
# Manages the UI within the game

##### SIGNALS #####
signal time_over

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_GAME_MESSAGE_DURATION := 1 #s

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"game_ui": $"PlayersDataUi",
	"chronometer": $"Chronometer",
	"screen_message": $"ScreenGameMessage"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.game_ui.hide()
	onready_paths.chronometer.hide()
	onready_paths.screen_message.hide()

##### PUBLIC METHODS #####
func init_game_ui(p_players_data : Dictionary) -> void:
	onready_paths.game_ui.clean()
	for player_idx in p_players_data.keys():
		onready_paths.game_ui.add_player(player_idx, p_players_data[player_idx].config, p_players_data[player_idx].lives)
		onready_paths.game_ui.rpc("update_lives", player_idx, p_players_data[player_idx].lives)
	onready_paths.game_ui.show()

func init_chronometer(game_time: float) -> void:
	if not onready_paths.chronometer.is_connected("time_over", _on_chronometer_time_over):
		onready_paths.chronometer.connect("time_over", _on_chronometer_time_over)
	onready_paths.chronometer.start_timer(game_time)
	onready_paths.chronometer.show()

func init_screen_game_message() -> void:
	onready_paths.screen_message.init()
	onready_paths.screen_message.show()

func update_movement(player_id: int, value) -> void:
	onready_paths.game_ui.rpc("update_movement", player_id, value)

func update_powerup(player_id : int, value) -> void:
	onready_paths.game_ui.rpc("update_powerup", player_id, value)

func update_lives(idx: int, lives: int) -> void:
	onready_paths.game_ui.rpc("update_lives", idx, lives)

func display_message(message: String, display_all_characters : bool = false) -> void:
	onready_paths.screen_message.rpc("display_message", message, PLAYER_GAME_MESSAGE_DURATION, display_all_characters)

func reset() -> void:
	onready_paths.game_ui.clean()
	onready_paths.game_ui.hide()
	onready_paths.chronometer.hide()
	onready_paths.screen_message.hide()

##### SIGNAL MANAGEMENT #####
func _on_chronometer_time_over() -> void:
	emit_signal("time_over")
