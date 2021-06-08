#!mainFile "../../main.opy"


def LucioSpeedBoost():
    @Name "[lucio.del] Subroutine: Speedboost"
    
    if eventPlayer.isInAlternateForm():
        return
    eventPlayer.SpeedboostBonus = 5 * (1 - eventPlayer.MusicMeter / 100) + 20 * (eventPlayer.MusicMeter / 100)
    while eventPlayer.isUsingAbility2():
        eventPlayer._extendedPlayerCollection[20] = 0
        while eventPlayer._extendedPlayerCollection[20] < len(eventPlayer.HeroMoveSpeedModifications):
            #Boost speed based on the music meter charge
            if distance(_objectVariable_1[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.HeroMoveSpeedModifications[eventPlayer._extendedPlayerCollection[20]]])[0]], eventPlayer.getPosition()) < 12 and not eventPlayer.isInAlternateForm():
                _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.HeroMoveSpeedModifications[eventPlayer._extendedPlayerCollection[20]]])[0]] = 100 + eventPlayer.SpeedboostBonus
            else:
                _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.HeroMoveSpeedModifications[eventPlayer._extendedPlayerCollection[20]]])[0]] = 100
            eventPlayer._extendedPlayerCollection[20] += 1
        wait(0.25)
    eventPlayer._extendedPlayerCollection[21] = 0
    while eventPlayer._extendedPlayerCollection[21] < len(eventPlayer.HeroMoveSpeedModifications):
        _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.HeroMoveSpeedModifications[eventPlayer._extendedPlayerCollection[21]]])[0]] = 100
        eventPlayer._extendedPlayerCollection[21] += 1


rule "[lucio.del] Speedboost":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility2() == true
    
    LucioSpeedBoost()


rule "[lucio.del] Speedboost (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.LUCIO
    @Condition eventPlayer.isUsingAbility2() == true
    
    LucioSpeedBoost()
