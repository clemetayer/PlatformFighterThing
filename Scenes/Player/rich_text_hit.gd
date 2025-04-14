@tool
extends RichTextEffect
class_name RichTextHit

# Syntax: [hit amplitude=5.0 progress=0.5 seed=1]some text[/hit]

# Define the tag name.
var bbcode = "hit"

func _process_custom_fx(char_fx):
	# Get parameters, or use the provided default value if missing.
    var amplitude = char_fx.env.get("amplitude", 50.0)
    var progress = char_fx.env.get("progress", 1.0)
    var char_seed = char_fx.env.get("seed",1)

    var rngx = RandomNumberGenerator.new()
    rngx.seed = (char_fx.relative_index + 1) * char_seed
    var randx = (0.5 - rngx.randf()) * 2.0 * float(amplitude)
    var rngy = RandomNumberGenerator.new()
    rngy.seed = (char_fx.relative_index + 1) * char_seed
    var randy = (0.5 - rngy.randf()) * 2.0 * float(amplitude)
    var rand_offset = Vector2(randx, randy)

    char_fx.offset = rand_offset * (1.0 - progress)
    return true