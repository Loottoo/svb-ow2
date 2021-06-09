#!mainFile "../../main.opy"


playervar tempDamageMod


subroutine McCreeInit


rule "[McCree] Initial":
  @Event eachPlayer
  @Hero mccree
  
  async(McCreeInit, AsyncBehavior.NOOP)


rule "[McCree]ยง Initial":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.MCCREE
  
  async(McCreeInit, AsyncBehavior.NOOP)


def McCreeInit():
  @Name "[Sub][McCree] Initial - Fan the hammer deals 64% damage after first bullet"
  
  if eventPlayer.HeroActive == Hero.MCCREE:
      return
  wait()
  eventPlayer.HeroActive = Hero.MCCREE
  startDamageModification(getAllPlayers(), eventPlayer, 64 if eventPlayer.isFiringSecondaryFire() else 100, DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
  eventPlayer.tempDamageMod = getLastDamageModification()
  #Wait for cleanup
  waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
  stopDamageModification(eventPlayer.tempDamageMod)
  eventPlayer.HeroActive.remove(Hero.MCCREE)
