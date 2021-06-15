#!mainFile "../../main.opy"



subroutine SymTP


rule "[Symmetra]  TP":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true

    async(SymTP, AsyncBehavior.NOOP)


rule "[Symmetra]ยง TP":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.SYMMETRA
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true

    async(SymTP, AsyncBehavior.NOOP)


def SymTP():
    @Name "[Sub][Symmetra] TP lasts 8 sec, cooldown begins when TP is put down"
    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isUsingAbility2() == false, 0.656)
    if eventPlayer.isUsingAbility2() == false:
        return
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)
    waitUntil(eventPlayer.getCurrentHero() == Hero.ECHO and eventPlayer.isDuplicatingAHero() == false or eventPlayer.isHoldingButton(Button.ABILITY_2), 8)
    if not (eventPlayer.getCurrentHero() == Hero.ECHO and not eventPlayer.isDuplicatingAHero()):
        eventPlayer.Index = eventPlayer.getAbilityCooldown(Button.ABILITY_2)
        eventPlayer.allowButton(Button.ABILITY_2)
        eventPlayer.forceButtonPress(Button.ABILITY_2)
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.Index)
