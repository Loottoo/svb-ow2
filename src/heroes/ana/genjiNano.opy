#!mainFile "../../main.opy"

#Is this variable for ana or genji? It seems to be used for both.
playervar nanoTarget

playervar potentialNanoTargets

#Is this useful for anything? It doesn't seem knowing which ana used the nano is useful.
rule "[Ana] Ana used nano on genji":
    @Event eachPlayer
    @Condition eventPlayer.hero == Hero.ANA
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.nanoTarget = null
    #Nano cast time delays the heal
    waitUntil(eventPlayer.nanoTarget != null, 0.16)
    if eventPlayer.nanoTarget == null:
        eventPlayer.potentialNanoTargets = [player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() == Hero.GENJI or player.getCurrentHero() == Hero.ECHO]
        for eventPlayer.Index in range(len(eventPlayer.potentialNanoTargets)):
            damage(eventPlayer.potentialNanoTargets[eventPlayer.Index], eventPlayer, 0.001 / 10)
    wait(8)
    eventPlayer.potentialNanoTargets.nanoTarget = null
