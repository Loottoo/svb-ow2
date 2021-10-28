#!mainFile "../../main.opy"


rule "[Genji] Shurikens +2 damage":
  @Event playerDealtDamage
  @Condition eventPlayer.hero == Hero.GENJI
  @Condition eventPlayer.isUsingUltimate() == false
  @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.SECONDARY_FIRE) == true

  damage(victim, attacker, eventDamage * (2/28))
