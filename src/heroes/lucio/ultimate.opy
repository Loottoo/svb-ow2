#!mainFile "../../main.opy"


def LucioSoundbarrier():
    @Name "[lucio.del] Subroutine: Soundbarrier"
    
    eventPlayer.SoundbarrierCalculation = round((750 * (100 + (max(10, min(10 * (1 - eventPlayer.MusicMeter / 100) + 20 * (eventPlayer.MusicMeter / 100), 20))))) / 100 - 750) if eventPlayer.MusicMeter >= musicMeterGain else 0
    waitUntil(eventPlayer.getHealthOfType(Health.SHIELDS) > 0 or not eventPlayer.isUsingUltimate(), 9999)
    if not RULE_CONDITION:
        return
    eventPlayer._extendedPlayerCollection[19] = 0
    while eventPlayer._extendedPlayerCollection[19] < len(getPlayersInRadius(eventPlayer.getPosition(), 30, eventPlayer.getTeam(), LosCheck.SURFACES)):
        #Apply additional shields to all nearby teammates
        evalOnce(getPlayersInRadius(eventPlayer.getPosition(), 30, eventPlayer.getTeam(), LosCheck.SURFACES)[eventPlayer._extendedPlayerCollection[19]]).addHealthPool(Health.SHIELDS, eventPlayer.SoundbarrierCalculation, false, true)
        eventPlayer.HeroHealthPools.append(getLastCreatedHealthPool())
        createEffect(getAllPlayers() if evalOnce(getPlayersInRadius(eventPlayer.getPosition(), 30, eventPlayer.getTeam(), LosCheck.SURFACES)[eventPlayer._extendedPlayerCollection[19]]).getHealthOfType(Health.SHIELDS) > 0 else null, Effect.LUCIO_SOUND_BARRIER_PROTECTED, eventPlayer.getTeam(), evalOnce(getPlayersInRadius(eventPlayer.getPosition(), 30, eventPlayer.getTeam(), LosCheck.SURFACES)[eventPlayer._extendedPlayerCollection[19]]), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.HeroEffects.append(getLastCreatedEntity())
        eventPlayer._extendedPlayerCollection[19] += 1
    wait(6 + eventPlayer.SoundbarrierCalculation / 125)
    CleanupHealthPools()
    CleanupEffects()


rule "[lucio.del] Soundbarrier":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate() == true
    
    LucioSoundbarrier()


rule "[lucio.del] Soundbarrier (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.LUCIO
    @Condition eventPlayer.isUsingUltimate() == true
    
    LucioSoundbarrier()
