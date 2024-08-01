extends Node
class_name ActionHandlerBase
# Base class to handle actions

##### ENUMS #####
enum states {INACTIVE, JUST_ACTIVE, ACTIVE, JUST_INACTIVE}

##### VARIABLES #####
#---- STANDARD -----
#==== PUBLIC ====
var jump := states.INACTIVE
var left := states.INACTIVE
var right := states.INACTIVE
var up := states.INACTIVE
var down := states.INACTIVE
var fire := states.INACTIVE

##### PUBLIC METHODS #####
# convenient method to quickly check if an action is active or not since JUST_ACTIVE has priority over ACTIVE
static func is_active(action : states) -> bool:
    return action == states.ACTIVE or action == states.JUST_ACTIVE

static func is_just_active(action: states) -> bool:
    return action == states.JUST_ACTIVE

static func is_just_inactive(action: states) -> bool:
    return action == states.JUST_INACTIVE