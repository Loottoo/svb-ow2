#!mainFile "../main.opy"


globalvar rolePassivesDamageMovementspeed = 100 + createWorkshopSetting(int[0:100], "Role passives", "Damage movement speed bonus", 15, 0)

subroutine setRolePassiveMovementSpeed

def setRolePassiveMovementSpeed():
  @Name "Subroutine - set movementspeed based on role passive"

  eventPlayer.setMoveSpeed(rolePassivesDamageMovementspeed if eventPlayer.getCurrentHero() in getDamageHeroes() or eventPlayer.getHeroOfDuplication() in getDamageHeroes() else 100)


rule "[all.del] Damage Passive":
  @Event eachPlayer
  @Condition (eventPlayer.getCurrentHero() in getDamageHeroes() or eventPlayer.getHeroOfDuplication() in getDamageHeroes()) == true
  
  if not eventPlayer.DamageMoveSpeedID:
      eventPlayer._extendedPlayerCollection[0] = 0
      while eventPlayer._extendedPlayerCollection[0] < len([].concat(eventPlayer)):
          LastMoveSpeedModificationID += 1
          eventPlayer._extendedPlayerCollection[1] = _classIndexes.index(0)
          _classIndexes[eventPlayer._extendedPlayerCollection[1]] = 8
          _objectVariable_3[eventPlayer._extendedPlayerCollection[1]] = []
          _objectVariable_4[eventPlayer._extendedPlayerCollection[1]] = 0
          _objectVariable_1[eventPlayer._extendedPlayerCollection[1]] = [].concat(eventPlayer)[eventPlayer._extendedPlayerCollection[0]]
          _objectVariable_0[eventPlayer._extendedPlayerCollection[1]] = LastMoveSpeedModificationID
          _objectVariable_2[eventPlayer._extendedPlayerCollection[1]] = rolePassivesDamageMovementspeed
          ActiveModifications.append(eventPlayer._extendedPlayerCollection[1])
          eventPlayer._extendedPlayerCollection[0] += 1
      eventPlayer.DamageMoveSpeedID = LastMoveSpeedModificationID
  _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.DamageMoveSpeedID])[0]] = rolePassivesDamageMovementspeed
  
  setRolePassiveMovementSpeed() # Temp fix for movementspeed not applying cause I don't get what's going on here

  waitUntil(not eventPlayer.getCurrentHero() in getDamageHeroes() and not eventPlayer.getHeroOfDuplication() in getDamageHeroes() or eventPlayer.getCurrentHero() == Hero.ECHO and eventPlayer.isDuplicatingAHero() and not eventPlayer.getHeroOfDuplication() in getDamageHeroes(), 9999)
  _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.DamageMoveSpeedID])[0]] = 100
  
  setRolePassiveMovementSpeed() # Temp fix for movementspeed not applying cause I don't get what's going on here

  waitUntil(eventPlayer.getCurrentHero() == Hero.ECHO and not eventPlayer.isDuplicatingAHero() or not eventPlayer.getCurrentHero() in getDamageHeroes(), 9999)
  if eventPlayer.getCurrentHero() == Hero.ECHO and not eventPlayer.isDuplicatingAHero():
      goto RULE_START
