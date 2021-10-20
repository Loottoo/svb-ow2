#!mainFile "../../main.opy"

globalvar sombraUnstealthSpeed = createWorkshopSetting(float[0:0.75], "Sombra", "Unstealth Speed", 0.45)

rule "[Sombra] Stealth Exit Quickly":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isUsingAbility1() == true

    wait(0.75)
    waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isHoldingButton(Button.MELEE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isHoldingButton(Button.ULTIMATE), 99999)
    if (not eventPlayer.isUsingAbility1()):
        return
    wait(sombraUnstealthSpeed)
    if (not eventPlayer.isUsingAbility1()):
        return
    eventPlayer.cancelPrimaryAction()

rule "[Sombra] If Sombra took damage while exiting stealth, exit stealth quickly":
        @Event playerTookDamage
        @Hero sombra
        @Condition eventPlayer.isUsingAbility1()

        wait(sombraUnstealthSpeed, Wait.ABORT_WHEN_FALSE)
        eventPlayer.cancelPrimaryAction()
