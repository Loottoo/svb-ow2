#!mainFile "../main.opy"


rule "[all.del] Support Passive":
  @Event playerTookDamage
  @Condition (eventPlayer.getCurrentHero() in getSupportHeroes() or eventPlayer.getHeroOfDuplication() in getSupportHeroes()) == true
  
  stopHoT(eventPlayer.SupportHealingID)
  wait(2, Wait.RESTART_WHEN_TRUE)
  eventPlayer.startHoT(eventPlayer, 9999, 10)
  eventPlayer.SupportHealingID = getLastHoT()


rule "[all.del] Stop Support Passive":
  @Event eachPlayer
  @Condition (not (eventPlayer.getCurrentHero() in getSupportHeroes() or eventPlayer.getHeroOfDuplication() in getSupportHeroes()) or eventPlayer.getNormalizedHealth() == 1) == true
  
  stopHoT(eventPlayer.SupportHealingID)
