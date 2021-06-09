#!mainFile "../../main.opy"


globalvar OverwriteButtonArray
globalvar SeparateAmmoEnabled


rule "Initial":
    OverwriteButtonArray = [null, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2]


rule "Initiate Player":
    @Event eachPlayer
    @Hero mei

    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()), 9999)

    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.INTERACT)
