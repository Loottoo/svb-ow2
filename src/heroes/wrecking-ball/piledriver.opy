#!mainFile "../../main.opy"

globalvar piledriverStrength = createWorkshopSetting(int[1:100], "Wrecking Ball", "Piledriver lift up (based on distance)    Lower = reduced strength, Higher = closer to live", 33, 0)

rule "[Wrecking Ball] Reduce Piledriver liftup":
  @Event playerDealtDamage
  @Condition eventPlayer.hero == Hero.HAMMOND
  @Condition eventAbility == Button.CROUCH
  
  victim.applyImpulse(Vector.DOWN, (100 - eventDamage) / piledriverStrength, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)

