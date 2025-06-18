extends Node

signal pause
signal unPause
signal showColors
signal hideColors

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
