#!mainFile "../../main.opy"


playervar ability2


subroutine SymTP


rule "[Symmetra]  TP":
  @Event eachPlayer
  @Hero symmetra
  @Condition eventPlayer.isUsingAbility2() == true
  @Condition eventPlayer.isFiringPrimaryFire() == false
  @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
  @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
  
  async(SymTP, AsyncBehavior.NOOP)


rule "[Symmetra]ยง TP":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.SYMMETRA
  @Condition eventPlayer.isUsingAbility2() == true
  @Condition eventPlayer.isFiringPrimaryFire() == false
  @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
  @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
  
  async(SymTP, AsyncBehavior.NOOP)


def SymTP():
  @Name "[Sub][Symmetra] TP lasts 8 sec, cooldown begins when TP is put down"
  
  eventPlayer.ability2 = 10
  chase(eventPlayer.ability2, 0, rate=1, ChaseReeval.NONE)
  eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
  eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)
  waitUntil(eventPlayer.getCurrentHero() == Hero.ECHO and eventPlayer.isDuplicatingAHero() == false or eventPlayer.isHoldingButton(Button.ABILITY_2), 8)
  if (eventPlayer.getCurrentHero() == Hero.ECHO and eventPlayer.isDuplicatingAHero() == false) == true:
      goto lbl_0
  eventPlayer.forceButtonPress(Button.ABILITY_2)
  eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.ability2)
  lbl_0:
