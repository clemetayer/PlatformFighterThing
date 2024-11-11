extends RefCounted
class_name FunctionUtils
# static function utils

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----

##### PUBLIC METHODS #####
static func in_between(value: float, compare1: float, compare2: float, strict : bool = false) -> bool:
	if strict: 
		return value > min(compare1, compare2) and value < max(compare1, compare2)
	return value >= min(compare1, compare2) and value <= max(compare1, compare2)

##### PROTECTED METHODS #####

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received

