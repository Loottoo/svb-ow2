#!mainFile "../../main.opy"


playervar tempDamageMod


def CleanupMccree():
    @Name "[mccree.del] Subroutine: Cleanup"
    
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    eventPlayer.setMaxHealth(100)
    stopDamageModification(eventPlayer.tempDamageMod)
    wait()
    eventPlayer.HeroActive = null


def InitialMccree():
    @Name "[mccree.del] Subroutine: Initial"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == Hero.MCCREE:
        return
    wait()
    eventPlayer.HeroActive = Hero.MCCREE
    #Character setup
    eventPlayer.setMaxHealth(88.889)
    startDamageModification(getAllPlayers(), eventPlayer, 64 if eventPlayer.isFiringSecondaryFire() else 100, DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
    eventPlayer.tempDamageMod = getLastDamageModification()
    async(CleanupMccree, AsyncBehavior.NOOP)


rule "[mccree.del] Initial":
    @Event eachPlayer
    @Hero mccree
    
    InitialMccree()


rule "[mccree.del] Initial (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MCCREE
    
    InitialMccree()
