#!mainFile "../main.opy"


globalvar LastMoveSpeedModificationID


playervar DamageMoveSpeedID


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
          _objectVariable_2[eventPlayer._extendedPlayerCollection[1]] = 115
          ActiveModifications.append(eventPlayer._extendedPlayerCollection[1])
          eventPlayer._extendedPlayerCollection[0] += 1
      eventPlayer.DamageMoveSpeedID = LastMoveSpeedModificationID
  _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.DamageMoveSpeedID])[0]] = 115
  waitUntil(not eventPlayer.getCurrentHero() in getDamageHeroes() and not eventPlayer.getHeroOfDuplication() in getDamageHeroes() or eventPlayer.getCurrentHero() == Hero.ECHO and eventPlayer.isDuplicatingAHero() and not eventPlayer.getHeroOfDuplication() in getDamageHeroes(), 9999)
  _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.DamageMoveSpeedID])[0]] = 100
  waitUntil(eventPlayer.getCurrentHero() == Hero.ECHO and not eventPlayer.isDuplicatingAHero() or not eventPlayer.getCurrentHero() in getDamageHeroes(), 9999)
  if eventPlayer.getCurrentHero() == Hero.ECHO and not eventPlayer.isDuplicatingAHero():
      goto RULE_START
