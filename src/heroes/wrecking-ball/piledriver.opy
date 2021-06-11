#!mainFile "../../main.opy"

globalvar piledriverStreght = createWorkshopSetting(int[1:100], "Wrecking Ball", "Piledriver lift up (based on distance)    Lower = reduced strenght, Higher = closer to live", 33, 0)

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
