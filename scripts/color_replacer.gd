extends CanvasLayer

@onready var overlay = $overlay
@onready var button_area = $Control/Bar/ButtonArea
@onready var close_button = $"Control/Bar/Close Button"
@onready var control = $Control
@onready var inverted = $Control/Bar/Inverted


const RAINYHEARTS = preload("res://art/font/rainyhearts.ttf")
var pallettes = {
		"Default":{
		"dark":"000000",
		"light":"ffffff"
	},
	"Casio":{
		"dark":"000000",
		"light":"83b07e"
	},
		"Nokia":{
		"dark":"43523d",
		"light":"c7f0d8"
	},
		"Gameboy":{
		"dark":"18232e",
		"light":"97bfa4"
	},
		"Virtual Boy":{
		"dark":"2b0000",
		"light":"cc0e13"
	},
	"Sepia":{
		"dark":"4e1503",
		"light":"fffda3"
	},
	"Dimmer":{
		"dark":"222323",
		"light":"f0f6f0"
	},
		"Nostalgi2":{
		"dark":"2e253d",
		"light":"b0b0b0"
	},
		"Postapocalyptic Sunset ":{
		"dark":"1d0f44",
		"light":"f44e38"
	},
		"Milk Carton":{
		"dark":"5b88e2",
		"light":"f5f4e9"
	},
		"Neutral Green":{
		"dark":"ffeaf9",
		"light":"004c3d"
	},
		"Blue Commodore":{
		"dark":"40318e",
		"light":"88d7de"
	},
		"The Night":{
		"dark":"413652",
		"light":"6493ff"
	},
		"Port":{
		"dark":"10368f",
		"light":"ff8e42"
	},
		"BitZantine":{
		"dark":"702963",
		"light":"ffbf00"
	},
		"Sangre":{
		"dark":"120628",
		"light":"610e0e"
	},
		"Pop It!":{
		"dark":"00d4ff",
		"light":"d61406"
	},
		"Resses":{
		"dark":"6f4d3d",
		"light":"cb9867"
	},
		"Paper":{
		"dark":"3e3e3e",
		"light":"f6e7c1"
	},
		"PaperBack":{
		"dark":"382b26",
		"light":"b8c2b9"
	},
		"Bit Bee":{
		"dark":"292b30",
		"light":"cfab4a"
	},
		"Space Station":{
		"dark":"a692b0",
		"light":"17141c"
	},
		"Grape":{
		"dark":"040612",
		"light":"d400ff"
	},
}
var currentPallette

# Called when the node enters the scene tree for the first time.
func _ready():
	currentPallette = "Default"
	setPallette()
	displayUI()
	inverted.pressed.connect(setPallette)
	close_button.pressed.connect(hideUI)
	control.visible = false
	pass # Replace with function body.

func hideUI():
	control.visible = false

func changeColor(TwoColorArr):
	overlay.material.set_shader_parameter("blackReplacement", TwoColorArr[0])
	overlay.material.set_shader_parameter("whiteReplacement", TwoColorArr[1])

func setPallette():
	var pallette_name = currentPallette
	var pallette = pallettes[pallette_name]
	if inverted.button_pressed == true:
		changeColor([Color(pallette.light), Color(pallette.dark)])
	else:
		changeColor([Color(pallette.dark), Color(pallette.light)])
	
func toggleUI():
	control.visible = !control.visible
	

func clearChildren(parentNode:Node):
	for n in parentNode.get_children():
		n.queue_free()
func displayUI():
	clearChildren(button_area)
	for p in pallettes:
		var pal = pallettes[p]
		var label = p
		var colors:Array[Color] = [Color(pal.dark), Color(pal.light) ]
		var invertedColors :Array[Color]= [Color(pal.light), Color(pal.dark) ]
		var button = Button.new()
		var buttonFunc = func setButtonPallette():
			currentPallette = label
			setPallette()
		button.text = label
		button.pressed.connect(buttonFunc)
		var normalStyle: StyleBoxFlat =genStyle(colors)
		var PressedStyle: StyleBoxFlat = genStyle(invertedColors)
		button.add_theme_font_override("font", RAINYHEARTS)
		button.add_theme_stylebox_override("normal", normalStyle)
		button.add_theme_stylebox_override("hover", PressedStyle)
		button.add_theme_stylebox_override("pressed", PressedStyle)
		button.add_theme_color_override("font_color", colors[0])
		button.add_theme_color_override("font_hover_color", colors[1])
		button.add_theme_color_override("font_pressed_color", colors[1])
		button_area.add_child(button)	
		pass

func genStyle(colors:Array[Color])-> StyleBoxFlat:
		var style:StyleBoxFlat = StyleBoxFlat.new()
		var thickness = 2
		style.bg_color = colors[1]
		style.border_color = colors[0]
		style.set_border_width_all(thickness)
		style.set_content_margin_all(10)
		return style

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggleUI()
