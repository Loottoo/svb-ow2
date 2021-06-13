#!mainFile "../../main.opy"


rule "Set baby D.va Ult charge to 0":
    @Event eachPlayer
    @Condition eventPlayer.hero == Hero.DVA
    @Condition eventPlayer.isInAlternateForm()

    #don't you already start with 0 ult charge as baby?
    eventPlayer.setUltCharge(0)
