@tool
extends HBoxContainer
# Counter player data ui type 

##### VARIABLES #####
#---- EXPORTS -----
@export var LIVES : int : set = set_lives

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"overflow":$"Overflow",
	"tokens":$"AmountLeft"
}

##### PUBLIC METHODS #####
func set_value(value) -> void:
	set_lives(int(value))

func set_lives(lives : int) -> void:
	for child in onready_paths.tokens.get_children():
		child.hide()
	for child_idx in range(min(3,lives)):
		onready_paths.tokens.get_child(child_idx).show()
	if(lives > 3):
		onready_paths.overflow.text = "+%d" % [lives - 3]
	else:
		onready_paths.overflow.text = ""
	LIVES = lives
