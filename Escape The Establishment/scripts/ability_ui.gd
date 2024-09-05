extends Control

@onready var letter = $AbilityPanel/GodotIsStupidIHateIt/LetterBackgroundPanel/AbilityLetter
@onready var text = $AbilityPanel/AbilityText
var basefontsize = 28
var a = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var newsize = $ProgressBar/Panel.size.x * 0.5
	$ProgressBar/Panel.size.x = $ProgressBar/Panel.size.x * 0.5
	print(newsize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var newsize = $ProgressBar/Panel.size.x * 0.5
	#$ProgressBar/Panel.size.x = newsize
	#print(newsize)
	#print(a)
	a = a + 0.1

## IMPORTANT!!!! percent is between 0-1 (0 is nothing, 1 is full)
func set_progress_percent(percent: float):
	$ProgressBar/Panel.size.x = $ProgressBar/Panel.size.x * percent

func undisplay_all():
	$AbilityPanel.visible = false
	$ProgressBar.visible = false
	
func display_hack():
	$AbilityPanel.visible = true
	text.get_label_settings().font_size = basefontsize
	letter.text = "E"
	text.text = "Hack"
	
func display_ability(ability_name: String):
	$AbilityPanel.visible = true
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
