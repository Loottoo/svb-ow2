#!mainFile "../../main.opy"


rule "Set baby D.va Ult charge to 0":
    @Event eachPlayer
    @Condition eventPlayer.hero == Hero.DVA
    @Condition eventPlayer.isInAlternateForm()

    eventPlayer.setUltCharge(0)
