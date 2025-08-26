extends RefCounted
class_name FunctionUtils
# static function utils
##### PUBLIC METHODS #####
static func in_between(value: float, compare1: float, compare2: float, strict : bool = false) -> bool:
	if strict: 
		return value > min(compare1, compare2) and value < max(compare1, compare2)
	return value >= min(compare1, compare2) and value <= max(compare1, compare2)
