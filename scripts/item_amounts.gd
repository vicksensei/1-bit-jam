extends CanvasLayer

@onready var woodLabel = $Control/Bar/VBoxContainer/Wood/Count 
@onready var stoneLabel = $Control/Bar/VBoxContainer/Stone/Count 
@onready var foodLabel = $Control/Bar/VBoxContainer/Food/Count 
@onready var coalLabel = $Control/Bar/VBoxContainer/Coal/Count

# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.itemPickup.connect(updateItem)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateItem(item):
	Global.addItem(item)
	match item:
		Global.itemType.wood:
			woodLabel.text = "x"+ str( Global.items.wood)
		Global.itemType.stone:
			stoneLabel.text = "x"+ str( Global.items.stone)
		Global.itemType.food:
			foodLabel.text = "x"+ str( Global.items.food)
		Global.itemType.coal:
			coalLabel.text = "x"+ str( Global.items.coal)	
	pass
