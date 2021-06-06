#!mainFile "../../main.opy"


rule "[Ashe] No ultimate charge while B.O.B is active":
  @Event eachPlayer
  @Hero ashe
  @Condition eventPlayer.isUsingUltimate() == true
  
  eventPlayer.setUltCharge(0)
  wait(0.064)
  if RULE_CONDITION:
      goto RULE_START


rule "[Ashe]§ No ultimate charge while B.O.B is active":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.ASHE
  @Condition eventPlayer.isUsingUltimate() == true
  
  eventPlayer.setUltCharge(0)
  wait(0.064)
  if RULE_CONDITION:
      goto RULE_START
