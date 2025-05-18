@tool
extends HBoxContainer
# Counter player data ui type 

##### VARIABLES #####
#---- EXPORTS -----
@export var DATA_ICON : String : set = set_icon
@export var QUANTITY : int : set = set_quantity

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"icon":$"Icon",
	"overflow":$"Overflow",
	"tokens":$"AmountLeft"
}

##### PUBLIC METHODS #####
func set_value(value) -> void:
	set_quantity(int(value))

@rpc("authority","call_local","reliable")
func set_icon(icon_path : String) -> void:
	onready_paths.icon.texture = load(icon_path)
	DATA_ICON = icon_path

func set_quantity(quantity : int) -> void:
	for child in onready_paths.tokens.get_children():
		child.hide()
	for child_idx in range(min(3,quantity)):
		onready_paths.tokens.get_child(child_idx).show()
	if(quantity > 3):
		onready_paths.overflow.text = "+%d" % [quantity - 3]
	else:
		onready_paths.overflow.text = ""
	QUANTITY = quantity
