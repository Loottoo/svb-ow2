#!mainFile "../../main.opy"


globalvar musicMeterGain = createWorkshopSetting(int[1:100], "Lucio", "Music Meter gain per second of wall riding", 25, 0)
globalvar musicMeterDrain = createWorkshopSetting(int[1:100], "Lucio", "Music Meter drain per second of not wall riding", 10, 1)


def CleanupLucio():
    @Name "[lucio.del] Subroutine: Cleanup"
    
    CleanupTexts()
    CleanupHealingMods()
    CleanupEffects()
    CleanupHealthPools()
    stopChasingVariable(eventPlayer.MusicMeter)
    stopChasingVariable(eventPlayer.WallrideTimer)
    eventPlayer.WallrideTimer = 0
    eventPlayer.MusicMeter = 0


def InitialLucio():
    @Name "[lucio.del] Subroutine: Initial"
    
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
