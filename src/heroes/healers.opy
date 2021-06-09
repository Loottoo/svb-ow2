#!mainFile "../main.opy"


globalvar rolePassivesHealAmount = createWorkshopSetting(int[0:100], "Role passives", "Healing heal amount", 10, 1)


rule "[all.del] Support Passive":
  @Event playerTookDamage
  @Condition (eventPlayer.getCurrentHero() in getSupportHeroes() or eventPlayer.getHeroOfDuplication() in getSupportHeroes()) == true
  
  stopHoT(eventPlayer.SupportHealingID)
  wait(2, Wait.RESTART_WHEN_TRUE)
  eventPlayer.startHoT(eventPlayer, 9999, rolePassivesHealAmount)
  eventPlayer.SupportHealingID = getLastHoT()


rule "[all.del] Stop Support Passive":
  @Event eachPlayer
  @Condition (not (eventPlayer.getCurrentHero() in getSupportHeroes() or eventPlayer.getHeroOfDuplication() in getSupportHeroes()) or eventPlayer.getNormalizedHealth() == 1) == true
  
  stopHoT(eventPlayer.SupportHealingID)
