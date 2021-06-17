#!mainFile "../../main.opy"


rule "Meteor Strike":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setPrimaryFireEnabled(true)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.setPrimaryFireEnabled(false)
