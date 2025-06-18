extends CanvasLayer

@onready var woodLabel = $Control/Bar/VBoxContainer/Wood/Count 
@onready var stoneLabel = $Control/Bar/VBoxContainer/Stone/Count 
@onready var foodLabel = $Control/Bar/VBoxContainer/Food/Count 
@onready var coalLabel = $Control/Bar/VBoxContainer/Coal/Count

@onready var build_campfire_indicator = $Control/BuildCampfireIndicator
@onready var eat_indicator = $Control/EatIndicator
@onready var dash_indicator = $Control/DashIndicator
@onready var gather_indicator = $Control/GatherIndicator

# Called when the node enters the scene tree for the first time.
func _ready():
	Signalbus.itemPickup.connect(addItem)
	Signalbus.useItem.connect(useItem)
	Signalbus.updateStamina.connect(updateActions)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateActions(s):
	if Global.playerStamina > 5:
		gather_indicator.visible = true
		dash_indicator.visible = true
	else:
		gather_indicator.visible = false
		dash_indicator.visible = false
	
func useItem(item:int, quantity):
	var amount:int = Global.getItemCount(item)
	if quantity <= amount:
		Global.useItem(item, quantity)
	updateItems()
	
func addItem(item):
	Global.addItem(item)
	updateItems()

func updateItems():
	woodLabel.text = "x"+ str( Global.items.wood)
	stoneLabel.text = "x"+ str( Global.items.stone)
	foodLabel.text = "x"+ str( Global.items.food)
	coalLabel.text = "x"+ str( Global.items.coal)	

	if Global.items.wood >=10 and Global.items.stone >=10:
		build_campfire_indicator.visible = true
	else:
		build_campfire_indicator.visible = false
	
	if Global.items.food >=1:
		eat_indicator.visible = true
	else:
		eat_indicator.visible = false
		
