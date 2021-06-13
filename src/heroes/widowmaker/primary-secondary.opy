#!mainFile "../../main.opy"


playervar ammo


rule "[Widowmaker] Bolt action":
  @Event eachPlayer
  @Condition eventPlayer.hero == Hero.WIDOWMAKER
  @Condition eventPlayer.isFiringSecondaryFire() == true
  @Condition eventPlayer.isFiringPrimaryFire() == true
  
  eventPlayer.setAmmo(0, 0)
