#!mainFile "../../main.opy"


def CleanupBaptiste():
  @Name "[baptiste.del] Subroutine: Cleanup"
  
  CleanupEffects()
  eventPlayer.allowButton(Button.ABILITY_2)
  CleanupHealingMods()
  CleanupMoveSpeedMods()


def InitialBaptiste():
  @Name "[baptiste.del] Subroutine: Initial"
  eventPlayer._extendedPlayerCollection[2] = 0
  while eventPlayer._extendedPlayerCollection[2] < len([].concat(eventPlayer)):
      LastMoveSpeedModificationID += 1
      eventPlayer._extendedPlayerCollection[3] = _classIndexes.index(0)
      _classIndexes[eventPlayer._extendedPlayerCollection[3]] = 8
      _objectVariable_3[eventPlayer._extendedPlayerCollection[3]] = []
      _objectVariable_4[eventPlayer._extendedPlayerCollection[3]] = 0
      _objectVariable_1[eventPlayer._extendedPlayerCollection[3]] = [].concat(eventPlayer)[eventPlayer._extendedPlayerCollection[2]]
      _objectVariable_0[eventPlayer._extendedPlayerCollection[3]] = LastMoveSpeedModificationID
      _objectVariable_2[eventPlayer._extendedPlayerCollection[3]] = 100
      ActiveModifications.append(eventPlayer._extendedPlayerCollection[3])
      eventPlayer._extendedPlayerCollection[2] += 1
  eventPlayer.BaptisteMoveSpeedID = LastMoveSpeedModificationID
  eventPlayer.HeroMoveSpeedModifications.append(LastMoveSpeedModificationID)
  #Healing modification to self
  startHealingModification(eventPlayer, eventPlayer, 50, HealingReeval.RECEIVERS_AND_HEALERS)
  eventPlayer.HeroHealingModifications.append(getLastHealingModification())
  eventPlayer.disallowButton(Button.ABILITY_2)
