#!mainFile "../../main.opy"


playervar tempDamageMod


rule "McCree cleanup":
    @Event eachPlayer
    @Condition eventPlayer.hero != Hero.MCCREE
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

    #This will very likely not affect the first bullet fired from FTH, is it intended?
    startDamageModification(getAllPlayers(), eventPlayer, 64 if eventPlayer.isFiringSecondaryFire() else 100, DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
    eventPlayer.tempDamageMod = getLastDamageModification()


rule "[mccree.del] Initial":
    @Event eachPlayer
    @Hero mccree
    
    InitialMccree()


rule "[mccree.del] Initial (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MCCREE
    
    InitialMccree()
