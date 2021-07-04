#!mainFile "../../main.opy"


def CleanupBaptiste():
  @Name "[baptiste.del] Subroutine: Cleanup"
  
  CleanupEffects()
  eventPlayer.allowButton(Button.ABILITY_2)
  CleanupHealingMods()


def InitialBaptiste():
  @Name "[baptiste.del] Subroutine: Initial"
  #Healing modification to self
  startHealingModification(eventPlayer, eventPlayer, 50, HealingReeval.RECEIVERS_AND_HEALERS)
  eventPlayer.HeroHealingModifications.append(getLastHealingModification())
  eventPlayer.disallowButton(Button.ABILITY_2)
