#!mainFile "../../main.opy"



playervar nanobladeDamageMod

subroutine UsedNanoBlade



rule "[Genji] Received Nano":
  @Event playerReceivedHealing
  @Condition healee.hero == Hero.GENJI
  @Condition healer.hero == Hero.ANA
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

rule "[Genji] Detected Nano+blade":
  @Event eachPlayer
  @Hero genji
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
