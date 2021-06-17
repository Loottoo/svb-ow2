#!mainFile "../../main.opy"


rule "[reinhardt.del] Refresh Firestrike":
  @Event eachPlayer
  @Hero reinhardt
  @Condition eventPlayer.isUsingAbility2() == true
  
  waitUntil(eventPlayer.isUsingAbility2() == false, 9999)
  eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)


rule "[reinhardt.del] Firestrike Recharge":
  @Event eachPlayer
  @Hero reinhardt
  @Condition floor(eventPlayer.ReinhardtFirestrikeCharges) < 2
  
  eventPlayer.ReinhardtFirestrikeCooldown = 6
  waitUntil(eventPlayer.ReinhardtFirestrikeCooldown == 0, 9999)
  eventPlayer.ReinhardtFirestrikeCharges = min(eventPlayer.ReinhardtFirestrikeCharges + 1, 2)
  if RULE_CONDITION:
      goto RULE_START


rule "[reinhardt.del] Firestrike Expends Charge":
  @Event eachPlayer
  @Hero reinhardt
  @Condition eventPlayer.isUsingAbility2() == true
  
  eventPlayer.ReinhardtFirestrikeCharges -= 1


rule "[reinhardt.del] Enable Firestrike when charges are available":
  @Event eachPlayer
  @Hero reinhardt
  @Condition floor(eventPlayer.ReinhardtFirestrikeCharges) > 0
  
  eventPlayer.setAbility2Enabled(true)


rule "[reinhardt.del] Disable Firestrike when charges are not available":
  @Event eachPlayer
  @Hero reinhardt
  @Condition floor(eventPlayer.ReinhardtFirestrikeCharges) <= 0
  
  eventPlayer.setAbility2Enabled(false)
