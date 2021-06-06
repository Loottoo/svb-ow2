#!mainFile "../../main.opy"


rule "[Widowmaker] Bolt action":
  @Event eachPlayer
  @Hero widowmaker
  @Condition eventPlayer.isFiringSecondaryFire() == true
  @Condition eventPlayer.isFiringPrimaryFire() == true
  
  eventPlayer.setAmmo(0, 0)


rule "[Widowmaker]§ Bolt action":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.WIDOWMAKER
  @Condition eventPlayer.isFiringSecondaryFire() == true
  @Condition eventPlayer.isFiringPrimaryFire() == true
  
  eventPlayer.setAmmo(0, 0)
