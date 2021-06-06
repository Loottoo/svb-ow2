#!mainFile "../../main.opy"


playervar nanoTarget
playervar nanobladeDamageMod
playervar potentialNanoTargets


subroutine AnaUsedNano
subroutine UsedNanoBlade


rule "[Genji] Ana used nano":
  @Event eachPlayer
  @Hero ana
  @Condition eventPlayer.isUsingUltimate() == true
  
  async(AnaUsedNano, AsyncBehavior.NOOP)


rule "[Genji]§ Ana used nano":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.ANA
  @Condition eventPlayer.isUsingUltimate() == true
  
  async(AnaUsedNano, AsyncBehavior.NOOP)


def AnaUsedNano():
  @Name "[Sub][Genji] Ana used nano"
  
  eventPlayer.nanoTarget = null
  #Nano cast time delays the heal
  waitUntil(eventPlayer.nanoTarget != null, 0.16)
  if eventPlayer.nanoTarget == null:
      eventPlayer.potentialNanoTargets = [player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() == Hero.GENJI or player.getCurrentHero() == Hero.ECHO]
      for eventPlayer.Index in range(len(eventPlayer.potentialNanoTargets)):
          damage(eventPlayer.potentialNanoTargets[eventPlayer.Index], eventPlayer, 0.001 / 10)
  wait(8)
  eventPlayer.potentialNanoTargets.nanoTarget = null


rule "[Genji] Recieved Nano":
  @Event playerReceivedHealing
  @Hero genji
  @Condition healer.getCurrentHero() == Hero.ANA
  @Condition eventAbility == Button.ULTIMATE
  
  eventPlayer.nanoTarget = eventPlayer


rule "[Genji]§ Recieved Nano":
  @Event playerReceivedHealing
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.GENJI
  @Condition healer.getCurrentHero() == Hero.ANA
  @Condition eventAbility == Button.ULTIMATE
  
  eventPlayer.nanoTarget = eventPlayer


rule "[Genji] Detect Nano (only if no heal event was detected)":
  @Event playerTookDamage
  @Hero genji
  @Condition eventAbility == null
  @Condition attacker.getTeam() == eventPlayer.getTeam()
  @Condition attacker.getCurrentHero() == Hero.ANA
  
  if eventDamage != 0.001 / 10:
      victim.nanoTarget = eventPlayer


rule "[Genji]§ Detect Nano (only if no heal event was detected)":
  @Event playerTookDamage
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.GENJI
  @Condition eventAbility == null
  @Condition attacker.getTeam() == eventPlayer.getTeam()
  @Condition attacker.getCurrentHero() == Hero.ANA
  
  if eventDamage != 0.001 / 10:
      victim.nanoTarget = eventPlayer


rule "[Genji] Detected Nano+blade":
  @Event eachPlayer
  @Hero genji
  @Condition eventPlayer.isUsingUltimate() == true
  @Condition eventPlayer.nanoTarget == eventPlayer
  
  async(UsedNanoBlade, AsyncBehavior.NOOP)


rule "[Genji]§ Detected Nano+blade":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.GENJI
  @Condition eventPlayer.isUsingUltimate() == true
  @Condition eventPlayer.nanoTarget == eventPlayer
  
  async(UsedNanoBlade, AsyncBehavior.NOOP)


def UsedNanoBlade():
  @Name "[Sub][Genji] Detected Nano+blade"
  
  startDamageModification(getAllPlayers(), eventPlayer, 100 / 1.5, DamageReeval.NONE)
  eventPlayer.nanobladeDamageMod = getLastDamageModification()
  waitUntil(eventPlayer.isUsingUltimate() == false or eventPlayer.nanoTarget == null, 9)
  stopDamageModification(eventPlayer.nanobladeDamageMod)
  eventPlayer.nanoTarget = null
