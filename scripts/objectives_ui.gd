extends CanvasLayer

@onready var build_house = $Bar/Objectives/BuildHouse
@onready var stone_objective = $Bar/Objectives/BuildHouse/VBoxContainer/StoneObjective
@onready var stone_count = $Bar/Objectives/BuildHouse/VBoxContainer/StoneObjective/StoneCount
@onready var wood_objective = $Bar/Objectives/BuildHouse/VBoxContainer/WoodObjective
@onready var wood_count = $Bar/Objectives/BuildHouse/VBoxContainer/WoodObjective/WoodCount

@onready var rescue_bunnies = $Bar/Objectives/RescueBunnies
@onready var bunny_objective = $Bar/Objectives/RescueBunnies/VBoxContainer/BunnyObjective
@onready var bunny_count = $Bar/Objectives/RescueBunnies/VBoxContainer/BunnyObjective/BunnyCount

@onready var bar = $Bar

func _ready():
	build_house.visible = true
	rescue_bunnies.visible= false
	Signalbus.itemAdded.connect(updateObjectives)
	Signalbus.fadeout.connect(hideUI)
	updateObjectives()

func updateObjectives():
	stone_count.text = str(Global.getItemCount(Global.itemType.stone) )+"/50"
	wood_count.text = str(Global.getItemCount(Global.itemType.wood) )+"/100"
	bunny_count.text = str(Global.getItemCount(Global.itemType.bunnies) )+"/15"
	var stoneComplete = checkObjective(stone_objective,Global.itemType.stone, 50)
	var woodComplete = checkObjective(wood_objective,Global.itemType.wood, 100)
	var bunniesComplete = checkObjective(bunny_objective,Global.itemType.bunnies, 15)
	
	if stoneComplete and woodComplete and Global.houseBuilt == false:
		Signalbus.fadeout.emit()		
		await Signalbus.fadeoutDone
		Signalbus.houseBuilt.emit()
		Global.houseBuilt = true
		Signalbus.useItem.emit(Global.itemType.wood, 100)
		Signalbus.useItem.emit(Global.itemType.stone, 50)
		build_house.visible = false
		rescue_bunnies.visible = true
		Signalbus.showText.emit("Now that the house is built, I need to find my bunnies")
		await Signalbus.textFinished
		Signalbus.fadein.emit()
		await Signalbus.fadeinDone
		showUI()
	if bunniesComplete and Global.houseBuilt == true:
		rescue_bunnies.visible = false
		Signalbus.fadeout.emit()	
		await Signalbus.fadeoutDone
		Signalbus.showText.emit("Game Win Screen under development")
	pass
	
func checkObjective(objective, type, amount):
	if Global.getItemCount(type) >= amount:
		objective.visible = false
		return true
	else:
		objective.visible = true
		return false

func hideUI():
	bar.visible = false

func showUI():
	bar.visible = true
