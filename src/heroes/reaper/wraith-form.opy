#!mainFile "../../main.opy"


rule "[Reaper] Wraith Form 2 sec":
  @Event eachPlayer
  @Hero reaper
  @Condition eventPlayer.isUsingAbility1() == true
  
  waitUntil(eventPlayer.isUsingAbility1() == false, 2)
  if eventPlayer.isUsingAbility1() == false:
      goto lbl_0
  eventPlayer.cancelPrimaryAction()
  lbl_0:


rule "[Reaper]§ Wraith Form 2 sec":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.REAPER
  @Condition eventPlayer.isUsingAbility1() == true
  
  waitUntil(eventPlayer.isUsingAbility1() == false, 2)
  if eventPlayer.isUsingAbility1() == false:
      goto lbl_0
  eventPlayer.cancelPrimaryAction()
  lbl_0:
