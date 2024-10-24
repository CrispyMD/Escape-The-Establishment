extends Control

func undisplay_all():
	$AbilityPanel.visible = false
	$InteractPanel.visible = false
	$ProgressBar.visible = false
	$SkillCheck.visible = false

### ABILITY ###

@onready var A_letter = $AbilityPanel/GodotIsStupidIHateIt/LetterBackgroundPanel/AbilityLetter
@onready var A_text = $AbilityPanel/AbilityText
var basefontsize = 28

func display_ability(ability_name: String):
	print("fdnkbob")
	A_text.get_label_settings().font_size = basefontsize
	match ability_name.to_lower():
		"runner":
			A_letter.text = "Q"
			A_text.text = "RunnnrernuLOSal"
		_:
			A_letter.text = "L"
			A_text.text = "oOOOPS!!"
	fix_A_text_size()
	$AbilityPanel.visible = true
	
func fix_A_text_size():
	while A_text.get_line_count() > 1:
		A_text.get_label_settings().font_size = A_text.get_label_settings().font_size - 1
	
### INTERACT ###

@onready var I_letter = $InteractPanel/GodotIsStupidIHateIt/LetterBackgroundPanel/AbilityLetter
@onready var I_text = $InteractPanel/AbilityText
	
func display_hack():
	$InteractPanel.visible = true
	I_text.get_label_settings().font_size = basefontsize
	I_letter.text = "E"
	I_text.text = "Hack"

func display_open_door():
	I_text.get_label_settings().font_size = basefontsize
	I_letter.text = "E"
	I_text.text = "Open"
	$InteractPanel.visible = true
	
func display_close_door():
	I_text.get_label_settings().font_size = basefontsize
	I_letter.text = "E"
	I_text.text = "Close"
	$InteractPanel.visible = true
	
func undisplay_interact():
	$InteractPanel.visible = false

### SKILLCHECK ###

func display_skillcheck():
	$SkillCheck.visible = true

func undisplay_skillcheck():
	$SkillCheck.visible = false

func increase_needle_rotation(rotation):
	$SkillCheck/Needle.rotation += rotation
	$SkillCheck/Needle.rotation = min($SkillCheck/Needle.rotation, 2 * PI)
	#clamping at full rotation

func get_needle_rotation():
	return $SkillCheck/Needle.rotation_degrees

func get_success_zone_degree():
	return $SkillCheck/SkillcheckRing.rotation_degrees + 225

### PROGRESS BAR ###

## IMPORTANT!!!! percent is between 0-1 (0 is nothing, 1 is full)
func set_progress_percent(percent: float):
	$ProgressBar/Panel.size.x = $ProgressBar.size.x * percent

func display_progress_bar():
	$ProgressBar.visible = true

func undisplay_progress_bar():
	$ProgressBar.visible = false
