#!mainFile "../../main.opy"


def ReinhardtRefreshFirestrike():
  @Name "[reinhardt.del] Subroutine: Refresh Firestrike"
  
  waitUntil(eventPlayer.isUsingAbility2() == false, 9999)
  eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)


rule "[reinhardt.del] Refresh Firestrike":
  @Event eachPlayer
  @Hero reinhardt
  @Condition eventPlayer.isUsingAbility2() == true
  
  ReinhardtRefreshFirestrike()


def ReinhardtFirestrikeRecharge():
  @Name "[reinhardt.del] Subroutine: Firestrike Recharge"
  
  eventPlayer.ReinhardtFirestrikeCooldown = 6
  waitUntil(eventPlayer.ReinhardtFirestrikeCooldown == 0, 9999)
  eventPlayer.ReinhardtFirestrikeCharges = min(eventPlayer.ReinhardtFirestrikeCharges + 1, 2)
  if RULE_CONDITION:
      goto RULE_START


rule "[reinhardt.del] Firestrike Recharge":
  @Event eachPlayer
  @Hero reinhardt
  @Condition floor(eventPlayer.ReinhardtFirestrikeCharges) < 2
  
  ReinhardtFirestrikeRecharge()


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


rule "[reinhardt.del] Refresh Firestrike (Duplication)":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
  @Condition eventPlayer.isUsingAbility2() == true
  
  ReinhardtRefreshFirestrike()


rule "[reinhardt.del] Firestrike Recharge (Duplication)":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
  @Condition floor(eventPlayer.ReinhardtFirestrikeCharges) < 2
  
  ReinhardtFirestrikeRecharge()


rule "[reinhardt.del] Firestrike Expends Charge (Duplication)":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
  @Condition eventPlayer.isUsingAbility2() == true
  
  eventPlayer.ReinhardtFirestrikeCharges -= 1


rule "[reinhardt.del] Enable Firestrike when charges are available (Duplication)":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
  @Condition floor(eventPlayer.ReinhardtFirestrikeCharges) > 0
  
  eventPlayer.setAbility2Enabled(true)


rule "[reinhardt.del] Disable Firestrike when charges are not available (Duplication)":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
  @Condition floor(eventPlayer.ReinhardtFirestrikeCharges) <= 0
  
  eventPlayer.setAbility2Enabled(false)
