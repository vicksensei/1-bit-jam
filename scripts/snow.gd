extends CPUParticles2D

func _ready():
	Signalbus.startSnow.connect(start_snow)
	Signalbus.endSnow.connect(stop_snow)

func start_snow():
	visible = true

func stop_snow():
	visible = false

func _process(delta):
	pass
