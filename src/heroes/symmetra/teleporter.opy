#!mainFile "../../main.opy"


rule "[Symmetra]  TP":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true

    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isUsingAbility2() == false, 0.656)
    if eventPlayer.isUsingAbility2() == false:
        return
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)
    waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_2), 8)
    eventPlayer.Index = eventPlayer.getAbilityCooldown(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.Index)

