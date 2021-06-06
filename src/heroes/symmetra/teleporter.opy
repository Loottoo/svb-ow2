#!mainFile "../../main.opy"


subroutine SymTP


rule "[Symmetra]  TP":
  @Event eachPlayer
  @Hero symmetra
  @Condition eventPlayer.isUsingAbility2() == true
  @Condition eventPlayer.isFiringPrimaryFire() == false
  @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
  @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
  
  SymTP()


rule "[Symmetra]§ TP":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.SYMMETRA
  @Condition eventPlayer.isUsingAbility2() == true
  @Condition eventPlayer.isFiringPrimaryFire() == false
  @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
  @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
  
  async(SymTP, AsyncBehavior.RESTART)


def SymTP():
  @Name "[Sub][Symmetra] TP lasts 8 sec, cooldown begins when TP is put down"
  
  eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
  eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)
  eventPlayer.disallowButton(Button.ABILITY_2)
  waitUntil(eventPlayer.getCurrentHero() == Hero.ECHO and not eventPlayer.isUsingUltimate(), 8)
  eventPlayer.allowButton(Button.ABILITY_2)
  eventPlayer.forceButtonPress(Button.ABILITY_2)
