#!mainFile "../../main.opy"


def CleanupReinhardt():
    @Name "[reinhardt.del] Subroutine: Cleanup"
    
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    CleanupHealthPools()
    CleanupTexts()
    eventPlayer.setMaxHealth(100)
    eventPlayer.setAbility2Enabled(true)
    stopChasingVariable(eventPlayer.ReinhardtFirestrikeCooldown)
    eventPlayer.stopAcceleration()
    wait()
    eventPlayer.HeroActive = null


def InitialReinhardt():
    @Name "[reinhardt.del] Subroutine: Initial"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == Hero.REINHARDT:
        return
    wait()
    eventPlayer.HeroActive = Hero.REINHARDT
    wait()
    #Variable setup
    eventPlayer.ReinhardtFirestrikeCharges = 2
    eventPlayer.ReinhardtFirestrikeCooldown = 0
    wait()
    chase(eventPlayer.ReinhardtFirestrikeCooldown, 0, rate=1, ChaseReeval.NONE)
    #Character setup
    eventPlayer.setMaxHealth(75)
    eventPlayer.addHealthPool(Health.NORMAL, 75, true, true)
    eventPlayer.HeroHealthPools.append(getLastCreatedHealthPool())
    eventPlayer.addHealthPool(Health.ARMOR, 100, true, true)
    eventPlayer.HeroHealthPools.append(getLastCreatedHealthPool())
    hudSubtext(eventPlayer, "{0}({1}) [{2}]".format(" \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n {0}".format("                                                                                                                            {0}".format("                                                                                                                            {0}".format("                                                                         "))), floor(eventPlayer.ReinhardtFirestrikeCharges) if floor(eventPlayer.ReinhardtFirestrikeCharges) > 0 else iconString(Icon.CROSS), iconString(Icon.CHECKMARK) if floor(eventPlayer.ReinhardtFirestrikeCharges) == 2 else ceil(eventPlayer.ReinhardtFirestrikeCooldown)), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.HeroTexts.append(getLastCreatedText())
    async(CleanupReinhardt, AsyncBehavior.NOOP)


rule "[reinhardt.del] Initial":
    @Event eachPlayer
    @Hero reinhardt
    
    InitialReinhardt()
