extends Node

signal startNewGame

signal pause
signal unPause
signal fadein
signal fadeout
signal fadeinDone
signal fadeoutDone
signal showColors
signal hideColors
signal toggleReplace(mode:bool)
signal gameOver
#Text
signal showText(text)
signal textFinished

signal startSnow
signal endSnow
signal goIndoors
signal goOutdoors
signal itemPickup(item_type)
signal useItem(item:int, quantity)
signal itemAdded

signal hitTree(whichTree, direction)
signal spawnWood(location)
signal hitRock(whichRock)
signal spawnRock(location)

signal directionChange(direction)
signal facingTree(whichTree)
signal facingFlame(whichFlame)
signal clearFacing

signal updateStamina(stamDelta)
signal updateWarmth(warmDelta)

signal houseBuilt
signal outOfStamina

signal saveBunnies

signal buildFire(direction)

#Sounds:
signal playTypeSound
