extends Node

signal startSnow
signal endSnow
signal itemPickup(item_type)

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

signal saveBunnies()
