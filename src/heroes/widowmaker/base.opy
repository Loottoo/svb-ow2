#!mainFile "../../main.opy"


def CleanupWidowmaker():
    @Name "[widowmaker.del] Subroutine: Cleanup"
    
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    CleanupDamageMods()
    wait()
    eventPlayer.HeroActive = null


def InitialWidowmaker():
    @Name "[widowmaker.del] Subroutine: Initial"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == Hero.WIDOWMAKER:
        return
    wait()
    eventPlayer.HeroActive = Hero.WIDOWMAKER
    async(CleanupWidowmaker, AsyncBehavior.NOOP)


rule "[widowmaker.del] Initial":
    @Event eachPlayer
    @Hero widowmaker
    
    InitialWidowmaker()


rule "[widowmaker.del] Initial (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.WIDOWMAKER
    
    InitialWidowmaker()
