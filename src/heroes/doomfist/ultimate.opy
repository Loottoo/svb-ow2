#!mainFile "../../main.opy"


rule "Meteor Strike":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setPrimaryFireEnabled(true)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.setPrimaryFireEnabled(false)

    
rule "Meteor Strike - ECHO":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DOOMFIST
    
    eventPlayer.setPrimaryFireEnabled(true)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.setPrimaryFireEnabled(false)
