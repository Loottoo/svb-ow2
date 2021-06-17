#!mainFile "../../main.opy"


playervar tempDamageMod


def CleanupMccree():
    @Name "[mccree.del] Subroutine: Cleanup"
    stopDamageModification(eventPlayer.tempDamageMod)


def InitialMccree():
    @Name "[mccree.del] Subroutine: Initial"
    #Character setup

    startDamageModification(getAllPlayers(), eventPlayer, 64 if eventPlayer.isFiringSecondaryFire() else 100, DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
    eventPlayer.tempDamageMod = getLastDamageModification()

