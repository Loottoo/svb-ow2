#!mainFile "../../main.opy"


globalvar soldierAmmoPerSecond = createWorkshopSetting(int[1:10], "Soldier: 76", "Ammo gain while running", 1, 0)


rule "[Soldier] Ammo regens while sprinting":
  @Event eachPlayer
  @Condition eventPlayer.hero == Hero.SOLDIER
  @Condition eventPlayer.isUsingAbility1() == true
  
  do:
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAmmo(0, min(eventPlayer.getMaxAmmo(0), eventPlayer.getAmmo(0) + soldierAmmoPerSecond))
  while RULE_CONDITION

