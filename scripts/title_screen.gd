extends Node2D

@onready var start_button = $CanvasLayer/ColorRect/Panel/VBoxContainer/StartButton
@onready var settings_button = $CanvasLayer/ColorRect/Panel/VBoxContainer/SettingsButton
@onready var exit = $CanvasLayer/ColorRect/Panel/VBoxContainer/Exit

@onready var gpu_particles_2d = $CanvasLayer/ColorRect/GPUParticles2D
@onready var cpu_particles_2d = $CanvasLayer/ColorRect/CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("web"):
		gpu_particles_2d.queue_free()
	else:
		cpu_particles_2d.queue_free()
	start_button.pressed.connect(onStart)
	settings_button.pressed.connect(onSettings)
	exit.pressed.connect(onExit)
	pass # Replace with function body.


func onStart():
	Signalbus.startNewGame.emit()
	pass
func onSettings():
	pass
func onExit():
	pass
