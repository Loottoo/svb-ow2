#!mainFile "../../main.opy"


rule "Set baby D.va Ult charge to 0":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()

    eventPlayer.setUltCharge(0)


rule "[Echo] Set baby D.va Ult charge to 0":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DVA
    @Condition eventPlayer.isInAlternateForm()

    eventPlayer.setUltCharge(0)
