extends Control
# simple p2p menu to play the game in multiplayer

##### SIGNALS #####
signal start_multiplayer_game

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths := {
	"ip":$"CenterContainer/VBoxContainer/IP/TextEdit",
	"port":$"CenterContainer/VBoxContainer/Port/LineEdit",
	"connection_type":$"CenterContainer/VBoxContainer/Type/OptionButton"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _start_host() -> void:
	var ip = _get_ip()
	var port = _get_port()
	print("starting as host on %s:%s" % [ip,port])
	# Start as server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer

func _start_client() -> void:
	var ip = _get_ip()
	var port = _get_port()
	print("starting as client on %s:%s" % [ip,port])
	# Start as client.
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer

func _start_game():
	# Hide the UI and unpause to start the game.
	hide()
	get_tree().paused = false
	emit_signal("start_multiplayer_game")

func _get_port() -> int:
	return int(onready_paths.port.text)

func _get_ip() -> String:
	return onready_paths.ip.text

func _get_connection_type() -> String:
	return onready_paths.connection_type.get_item_text(onready_paths.connection_type.selected)

##### SIGNAL MANAGEMENT #####
func _on_start_game_button_pressed():
	match _get_connection_type():
		"Host":
			_start_host()
		"Client":
			_start_client()
	_start_game()
