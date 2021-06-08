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
    for eventPlayer.slot in range(5):
        startDamageModification(getPlayersInSlot(evalOnce(eventPlayer.slot), getOppositeTeam(eventPlayer.getTeam())), eventPlayer, min(max(50, distance(eventPlayer, getPlayersInSlot(evalOnce(eventPlayer.slot), getOppositeTeam(eventPlayer.getTeam()))) * 3.333), 100) if not eventPlayer.isMeleeing() and eventPlayer.isFiringSecondaryFire() else 100, DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
        eventPlayer.HeroDamageModifications.append(getLastDamageModification())
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
