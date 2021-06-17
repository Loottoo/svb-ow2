#!mainFile "../../main.opy"


rule "[zarya.del] Refresh Bubble":
    @Event eachPlayer
    @Hero zarya
    @Condition (eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0 or eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0) == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "[zarya.del] Bubble Recharge":
    @Event eachPlayer
    @Hero zarya
    @Condition floor(eventPlayer.ZaryaBubbleCharges) < ZaryaBubbleMaxCharges
    
    eventPlayer.ZaryaBubbleCooldown = ZaryaBubbleCooldown
    waitUntil(eventPlayer.ZaryaBubbleCooldown == 0, 9999)
    eventPlayer.ZaryaBubbleCharges = min(eventPlayer.ZaryaBubbleCharges + 1, ZaryaBubbleMaxCharges)
    if RULE_CONDITION:
        goto RULE_START


rule "[zarya.del] Bubble Expends Charge (Ability 1)":
    @Event eachPlayer
    @Condition eventPlayer.hero == Hero.ZARYA
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.ZaryaBubbleCharges -= 1


rule "[zarya.del] Bubble Expends Charge (Ability 2)":
    @Event eachPlayer
    @Condition eventPlayer.hero == Hero.ZARYA
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.ZaryaBubbleCharges -= 1


rule "[zarya.del] Enable Bubble when charges are available":
    @Event eachPlayer
    @Hero zarya
    @Condition floor(eventPlayer.ZaryaBubbleCharges) > 0
    
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)


rule "[zarya.del] Disable Bubble when charges are not available":
    @Event eachPlayer
    @Hero zarya
    @Condition floor(eventPlayer.ZaryaBubbleCharges) <= 0
    
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
