#!mainFile "../../main.opy"


rule "[Soldier] Ammo regens while sprinting":
  @Event eachPlayer
  @Hero soldier
  @Condition eventPlayer.isUsingAbility1() == true
  
  wait(0.25, Wait.ABORT_WHEN_FALSE)
  while eventPlayer.isUsingAbility1():
      wait(0.25, Wait.ABORT_WHEN_FALSE)
      eventPlayer.setAmmo(0, min(eventPlayer.getMaxAmmo(0), eventPlayer.getAmmo(0) + 1))


rule "[Soldier]§ Ammo regens while sprinting":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.SOLDIER
  @Condition eventPlayer.isUsingAbility1() == true
  
  wait(0.25, Wait.ABORT_WHEN_FALSE)
  while eventPlayer.isUsingAbility1():
      wait(0.25, Wait.ABORT_WHEN_FALSE)
      eventPlayer.setAmmo(0, min(eventPlayer.getMaxAmmo(0), eventPlayer.getAmmo(0) + 1))
