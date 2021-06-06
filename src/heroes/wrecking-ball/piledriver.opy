#!mainFile "../../main.opy"

globalvar piledriverStreght

rule "[Wrecking Ball] Reduce Piledriver liftup":
  @Event playerDealtDamage
  @Hero hammond
  @Condition eventAbility == Button.CROUCH
  
  victim.applyImpulse(Vector.DOWN, (100 - eventDamage) / piledriverStreght, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "[Wrecking Ball]§ Reduce Piledriver liftup":
  @Event playerDealtDamage
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.HAMMOND
  @Condition eventAbility == Button.CROUCH
  
  victim.applyImpulse(Vector.DOWN, (100 - eventDamage) / piledriverStreght, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
