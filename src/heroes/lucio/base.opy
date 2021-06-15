#!mainFile "../../main.opy"


globalvar musicMeterGain = createWorkshopSetting(int[1:100], "Lucio", "Music Meter gain per second of wall riding", 25, 0)
globalvar musicMeterDrain = createWorkshopSetting(int[1:100], "Lucio", "Music Meter drain per second of not wall riding", 10, 1)


def CleanupLucio():
    @Name "[lucio.del] Subroutine: Cleanup"
    
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    CleanupTexts()
    CleanupHealingMods()
    CleanupEffects()
    CleanupHealthPools()
    CleanupMoveSpeedMods()
    stopChasingVariable(eventPlayer.MusicMeter)
    stopChasingVariable(eventPlayer.WallrideTimer)
    eventPlayer.WallrideTimer = 0
    eventPlayer.MusicMeter = 0
    wait()
    eventPlayer.HeroActive = null


def InitialLucio():
    @Name "[lucio.del] Subroutine: Initial"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == Hero.LUCIO:
        return
    wait()
    eventPlayer.HeroActive = Hero.LUCIO
    #Healing mod
    startHealingModification(getPlayers(eventPlayer.getTeam()), eventPlayer, 100 + (0 * (1 - eventPlayer.MusicMeter / 100) + 20 * (eventPlayer.MusicMeter / 100) if eventPlayer.isUsingAbility2() and eventPlayer.MusicMeter >= musicMeterGain else 0), HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
    eventPlayer.HeroHealingModifications.append(getLastHealingModification())
    eventPlayer._extendedPlayerCollection[14] = _classIndexes.index(0)
    _classIndexes[eventPlayer._extendedPlayerCollection[14]] = 1
    eventPlayer._extendedPlayerCollection[15] = _classIndexes.index(0)
    _classIndexes[eventPlayer._extendedPlayerCollection[15]] = 1
    eventPlayer._extendedPlayerCollection[16] = _classIndexes.index(0)
    _classIndexes[eventPlayer._extendedPlayerCollection[16]] = 1
    #Create Hud
    progressBarHud(eventPlayer, eventPlayer.MusicMeter, "{0} Music Meter {0}".format(abilityIconString(Hero.LUCIO, Button.ABILITY_1)), HudPosition.TOP, 1, rgb((100 - eventPlayer.MusicMeter) * 2.55, eventPlayer.MusicMeter * 2.55, 0) if eventPlayer.isInAlternateForm() else rgb(255, eventPlayer.MusicMeter * 2.55, 0), Color.WHITE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)
    eventPlayer.HeroTexts.append(getLastCreatedText())
    chase(eventPlayer.WallrideTimer, 1 if eventPlayer.isOnWall() else 0, rate=100 if eventPlayer.isOnWall() else 1, ChaseReeval.DESTINATION_AND_RATE)
    chase(eventPlayer.MusicMeter, 100 if eventPlayer.isOnWall() or (eventPlayer.isOnWall() and (eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility2())) else 0, rate=0 if eventPlayer.WallrideTimer > 0 and not eventPlayer.isOnWall() else musicMeterGain if eventPlayer.isOnWall() or (eventPlayer.isOnWall() and (eventPlayer.isUsingUltimate() or eventPlayer.isUsingAbility2())) else musicMeterDrain, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.slot_2 = 0
    while eventPlayer.slot_2 < 5:
        eventPlayer._extendedPlayerCollection[17] = 0
        while eventPlayer._extendedPlayerCollection[17] < len([].concat(getPlayersInSlot(evalOnce(eventPlayer.slot_2), eventPlayer.getTeam()))):
            LastMoveSpeedModificationID += 1
            eventPlayer._extendedPlayerCollection[18] = _classIndexes.index(0)
            _classIndexes[eventPlayer._extendedPlayerCollection[18]] = 8
            _objectVariable_3[eventPlayer._extendedPlayerCollection[18]] = []
            _objectVariable_4[eventPlayer._extendedPlayerCollection[18]] = 0
            _objectVariable_1[eventPlayer._extendedPlayerCollection[18]] = [].concat(getPlayersInSlot(evalOnce(eventPlayer.slot_2), eventPlayer.getTeam()))[eventPlayer._extendedPlayerCollection[17]]
            _objectVariable_0[eventPlayer._extendedPlayerCollection[18]] = LastMoveSpeedModificationID
            _objectVariable_2[eventPlayer._extendedPlayerCollection[18]] = 100
            ActiveModifications.append(eventPlayer._extendedPlayerCollection[18])
            eventPlayer._extendedPlayerCollection[17] += 1
        eventPlayer.HeroMoveSpeedModifications.append(LastMoveSpeedModificationID)
        wait()
        eventPlayer.slot_2 += 1
    async(CleanupLucio, AsyncBehavior.NOOP)


rule "[lucio.del] Initial":
    @Event eachPlayer
    @Hero lucio
    
    InitialLucio()


rule "[lucio.del] Initial (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.LUCIO
    
    InitialLucio()
