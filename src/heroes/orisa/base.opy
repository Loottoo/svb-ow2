#!mainFile "../../main.opy"


def CleanupOrisa():
    @Name "[orisa.del] Subroutine: Cleanup"
    
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    CleanupTexts()
    CleanupEffects()
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    CleanupMoveSpeedMods()
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.stopForcingThrottle()
    eventPlayer.stopFacing()
    eventPlayer.stopCamera()
    eventPlayer.enablePlayerCollision()
    wait()
    eventPlayer.HeroActive = null


def InitialOrisa():
    @Name "[orisa.del] Subroutine: Initial"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == Hero.ORISA:
        return
    wait()
    eventPlayer.HeroActive = Hero.ORISA
    eventPlayer.disallowButton(Button.ABILITY_2)
    wait()
    #Create Hud
    hudSubtext(eventPlayer, "{0}({1})".format(" \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n {0}".format("                                                                                                                            {0}".format("                                                                                                                            {0}".format("                                                                             "))), "Gallop"), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    eventPlayer.HeroTexts.append(getLastCreatedText())
    eventPlayer.setProjectileSpeed(125)
    eventPlayer._extendedPlayerCollection[10] = 0
    while eventPlayer._extendedPlayerCollection[10] < len([].concat(eventPlayer)):
        LastMoveSpeedModificationID += 1
        eventPlayer._extendedPlayerCollection[11] = _classIndexes.index(0)
        _classIndexes[eventPlayer._extendedPlayerCollection[11]] = 8
        _objectVariable_3[eventPlayer._extendedPlayerCollection[11]] = []
        _objectVariable_4[eventPlayer._extendedPlayerCollection[11]] = 0
        _objectVariable_1[eventPlayer._extendedPlayerCollection[11]] = [].concat(eventPlayer)[eventPlayer._extendedPlayerCollection[10]]
        _objectVariable_0[eventPlayer._extendedPlayerCollection[11]] = LastMoveSpeedModificationID
        _objectVariable_2[eventPlayer._extendedPlayerCollection[11]] = 100
        ActiveModifications.append(eventPlayer._extendedPlayerCollection[11])
        eventPlayer._extendedPlayerCollection[10] += 1
    eventPlayer.OrisaMoveSpeedID = LastMoveSpeedModificationID
    eventPlayer.HeroMoveSpeedModifications.append(LastMoveSpeedModificationID)
    async(CleanupOrisa, AsyncBehavior.NOOP)


rule "[orisa.del] Initial":
    @Event eachPlayer
    @Hero orisa
    
    InitialOrisa()


rule "[orisa.del] Initial (Duplicate)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.ORISA
    
    InitialOrisa()
