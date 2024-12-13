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


@onready var A_bar = $AbilityPanel/Bar
@export var Ability_bar_size: float = 1.0

func change_ability_bar_color_to_active():
	var stylebox = A_bar.get_theme_stylebox("panel").duplicate()
	stylebox.set("bg_color", Color(0.416, 0.041, 0.346, 0.863))
	A_bar.add_theme_stylebox_override("panel", stylebox)

func tween_ability_bar(duration: float, to_x_mult: float):
	var newsize: Vector2 = $AbilityPanel.size
	newsize = Vector2(newsize.x * to_x_mult, newsize.y)
	var tween = create_tween()
	tween.tween_property($AbilityPanel/Bar, "size", newsize, duration).set_trans(Tween.TRANS_LINEAR)

func display_ability(ability: player.Ability):
	print("fdnkbob")
	A_text.get_label_settings().font_size = basefontsize
	match ability:
		player.Ability.Runner:
			A_letter.text = "Q"
			A_text.text = "Runner"
		player.Ability.Trapper:
			A_letter.text = "Q"
			A_text.text = "Trapper"
		_:
			A_letter.text = "L"
			A_text.text = "oOOOPS!!"
	fix_A_text_size()
	$AbilityPanel.visible = true
	
func fix_A_text_size():
	while A_text.get_line_count() > 1:
		A_text.get_label_settings().font_size = A_text.get_label_settings().font_size - 1
	
#region INTERACT

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

#endregion
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



### STATUS EFFECTS OR SOME SHIT LIKE TRAPPED ###

@export var effectDuration: float = 0.0
func _process(delta: float) -> void:
	$StatusEffect/VBox/DurationLabel.text = "%0.1f" % effectDuration
	
	#A_bar.size.x = $AbilityPanel.size.x * Ability_bar_size

	
func set_status_effect(effect: String, duration: float):
	$StatusEffect.visible = true
	$StatusEffect/VBox/EffectLabel.text = effect.to_upper()
	effectDuration = duration
	tween_value(duration)
	#$StatusEffect/VBox/DurationLabel.text = str(duration)
	
func tween_value(duration: float):
	var tween = create_tween()
	tween.tween_property(self, "effectDuration", 0, duration).set_trans(Tween.TRANS_LINEAR)
	
func undisplay_status_effect():
	$StatusEffect.visible = false
