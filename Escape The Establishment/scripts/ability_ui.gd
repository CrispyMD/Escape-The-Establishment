extends Control

@onready var letter = $AbilityPanel/GodotIsStupidIHateIt/LetterBackgroundPanel/AbilityLetter
@onready var text = $AbilityPanel/AbilityText
var basefontsize = 28

## IMPORTANT!!!! percent is between 0-1 (0 is nothing, 1 is full)
func set_progress_percent(percent: float):
	$ProgressBar/Panel.size.x = $ProgressBar.size.x * percent

func undisplay_all():
	$AbilityPanel.visible = false
	$ProgressBar.visible = false
	$SkillCheck.visible = false

func display_progress_bar():
	$ProgressBar.visible = true

func undisplay_progress_bar():
	$ProgressBar.visible = false

func display_hack():
	$AbilityPanel.visible = true
	text.get_label_settings().font_size = basefontsize
	letter.text = "E"
	text.text = "Hack"

func undisplay_hack():
	$AbilityPanel.visible = false

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
