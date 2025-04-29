@tool
extends HBoxContainer
# Counter player data ui type 

##### VARIABLES #####
#---- EXPORTS -----
@export var DATA_ICON : Texture : set = set_icon
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

func set_icon(icon : Texture) -> void:
	onready_paths.icon.texture = icon
	DATA_ICON = icon

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
