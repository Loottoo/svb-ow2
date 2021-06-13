#!mainFile "../../main.opy"


rule "[Ashe] No ultimate charge while B.O.B is active":
  @Event eachPlayer
  @Condition eventPlayer.hero == Hero.ASHE
  @Condition eventPlayer.isUsingUltimate() == true

  do:
    eventPlayer.setUltCharge(0)
    wait(0.064)
  while RULE_CONDITION
