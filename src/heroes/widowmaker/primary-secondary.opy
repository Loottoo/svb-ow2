#!mainFile "../../main.opy"


playervar ammo


#subroutine Sub13


rule "[Widowmaker] Bolt action":
  @Event eachPlayer
  @Condition eventPlayer.hero == Hero.WIDOWMAKER
  @Condition eventPlayer.isFiringSecondaryFire() == true
  @Condition eventPlayer.isFiringPrimaryFire() == true
  
  eventPlayer.setAmmo(0, 0)

#Unused
/*def Sub13():
  @Name "[Sub][Widowmaker] Bolt action"
  
  eventPlayer.ammo = eventPlayer.getAmmo(0)
  eventPlayer.forceButtonPress(Button.RELOAD)
  if eventPlayer.getAmmo(0) == 0:
      goto lbl_0
  wait(1)
  eventPlayer.cancelPrimaryAction()
  eventPlayer.setAmmo(0, eventPlayer.ammo)
  lbl_0:*/
