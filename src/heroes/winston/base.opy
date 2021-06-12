#!mainFile "../../main.opy"


def CleanupWinston():
    @Name "[winston.del] Subroutine: Cleanup"
    
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    CleanupHealthPools()
    eventPlayer.setMaxHealth(100)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    wait()
    eventPlayer.HeroActive = null


def InitialWinston():
    @Name "[winston.del] Subroutine: Initial"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == Hero.WINSTON:
        return
    wait()
    eventPlayer.HeroActive = Hero.WINSTON
    #Character setup
    eventPlayer.setMaxHealth(92.857)
    eventPlayer.addHealthPool(Health.NORMAL, 60.714 + 50 if eventPlayer.isUsingUltimate() else 75, true, true)
    eventPlayer.HeroHealthPools.append(getLastCreatedHealthPool())
    eventPlayer.addHealthPool(Health.ARMOR, 10.7 if eventPlayer.isUsingUltimate() else 10.7, true, true)
    eventPlayer.HeroHealthPools.append(getLastCreatedHealthPool())
    async(CleanupWinston, AsyncBehavior.NOOP)


rule "[winston.del] Initial":
    @Event eachPlayer
    @Hero winston
    
    InitialWinston()


rule "[winston.del] Initial (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.WINSTON
    
    InitialWinston()
