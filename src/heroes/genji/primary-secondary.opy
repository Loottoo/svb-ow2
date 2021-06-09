#!mainFile "../../main.opy"


rule "[Genji] Shurikens +2 damage":
  @Event playerDealtDamage
  @Hero genji
  @Condition eventPlayer.isUsingUltimate() == false
  @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.SECONDARY_FIRE) == true
  
  damage(victim, attacker, eventDamage * (2/28))


rule "[Genji]§ Shurikens +2 damage":
  @Event playerDealtDamage
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.GENJI
  @Condition eventPlayer.isUsingUltimate() == false
  @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.SECONDARY_FIRE) == true
  
  damage(victim, attacker, eventDamage * (2/28))
