extends Control

@onready var letter = $BackgroundPanel/GodotIsStupidIHateIt/LetterBackgroundPanel/AbilityLetter
@onready var text = $BackgroundPanel/AbilityText
var basefontsize = 28
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func display_hack():
	text.get_label_settings().font_size = basefontsize
	letter.text = "E"
	text.text = "Hack"
	
func display_ability(ability_name: String):
	text.get_label_settings().font_size = basefontsize
	match ability_name.to_lower():
		"Runner":
			letter.text = "Q"
			text.text = "RunnnrernuLOSal"
		_:
			letter.text = "L"
			text.text = "oOOOPS!!"
	fix_text_size()
			
func fix_text_size():
	while text.get_line_count() > 1:
		text.get_label_settings().font_size = text.get_label_settings().font_size - 1
	#kill me pleaes this took way too long i hate godot ioajickltadnfka,