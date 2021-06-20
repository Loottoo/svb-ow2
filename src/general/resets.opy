#!mainFile "../main.opy"


playervar hero

subroutine CleanupReaper
subroutine CleanupTracer
subroutine CleanupMercy
subroutine CleanupHanzo
subroutine CleanupTorbjorn
subroutine CleanupReinhardt
subroutine CleanupPharah
subroutine CleanupWinston
subroutine CleanupWidowmaker
subroutine CleanupBastion
subroutine CleanupSymmetra
subroutine CleanupZenyatta
subroutine CleanupGenji
subroutine CleanupRoadhog
subroutine CleanupMccree
subroutine CleanupJunkrat
subroutine CleanupZarya
subroutine CleanupSoldier
subroutine CleanupLucio
subroutine CleanupDva
subroutine CleanupMei
subroutine CleanupSombra
subroutine CleanupDoomfist
subroutine CleanupAna
subroutine CleanupOrisa
subroutine CleanupBrigitte
subroutine CleanupMoira
subroutine CleanupWreckingball
subroutine CleanupAshe
subroutine CleanupEcho
subroutine CleanupBaptiste
subroutine CleanupSigma

subroutine CleanSlate

subroutine InitialReaper
subroutine InitialTracer
subroutine InitialMercy
subroutine InitialHanzo
subroutine InitialTorbjorn
subroutine InitialReinhardt
subroutine InitialPharah
subroutine InitialWinston
subroutine InitialWidowmaker
subroutine InitialBastion
subroutine InitialSymmetra
subroutine InitialZenyatta
subroutine InitialGenji
subroutine InitialRoadhog
subroutine InitialMccree
subroutine InitialJunkrat
subroutine InitialZarya
subroutine InitialSoldier
subroutine InitialLucio
subroutine InitialDva
subroutine InitialMei
subroutine InitialSombra
subroutine InitialDoomfist
subroutine InitialAna
subroutine InitialOrisa
subroutine InitialBrigitte
subroutine InitialMoira
subroutine InitialWreckingball
subroutine InitialAshe
subroutine InitialEcho
subroutine InitialBaptiste
subroutine InitialSigma

def CleanSlate():
    @Name "Subroutine: Clean Slate (for general hero cleanup)"

    # We don't want to have dummy bots summoned by abilities (e.g. Symmetra Light Clone) to be affected by the clean slate code
    if not (eventPlayer.isDummy() and eventPlayer.getSlot() > 4):
        eventPlayer.setPrimaryFireEnabled(true)
        eventPlayer.setSecondaryFireEnabled(true)
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setAbility2Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.setMeleeEnabled(true)

        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)

        eventPlayer.setMaxHealth(8/9 * 100 if eventPlayer.getCurrentHero() == Hero.MCCREE else 92.857 if eventPlayer.getCurrentHero() == Hero.WINSTON else 100)
        eventPlayer.removeAllHealthPools()
        
        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.allowButton(Button.ABILITY_1)
        eventPlayer.allowButton(Button.ABILITY_2)
        eventPlayer.allowButton(Button.ULTIMATE)
        eventPlayer.allowButton(Button.INTERACT)

        eventPlayer.setDamageDealt(100)
        eventPlayer.setGravity(100)
        eventPlayer.setJumpVerticalSpeed(100)
        eventPlayer.setProjectileGravity(100)
        eventPlayer.setProjectileSpeed(100)
        eventPlayer.stopForcingThrottle()
        eventPlayer.stopFacing()
        eventPlayer.stopCamera()
        eventPlayer.enablePlayerCollision()

rule "Player changed hero":
    @Event eachPlayer
    @Condition (eventPlayer.hero != eventPlayer.getCurrentHero())
    do:
        #Here a cleanup subroutine will be called, this should be defined by each developer for their specific hero, called CleanupHERO (all hero names are spelled with one Capital then all lowercase)

        switch eventPlayer.hero:
            case Hero.REAPER:
                CleanupReaper()
                break
            case Hero.TRACER:
                CleanupTracer()
                break
            case Hero.MERCY:
                CleanupMercy()
                break
            case Hero.HANZO:
                CleanupHanzo()
                break
            case Hero.TORBJORN:
                CleanupTorbjorn()
                break
            case Hero.REINHARDT:
                CleanupReinhardt()
                break
            case Hero.PHARAH:
                CleanupPharah()
                break
            case Hero.WINSTON:
                CleanupWinston()
                break
            case Hero.WIDOWMAKER:
                CleanupWidowmaker()
                break
            case Hero.BASTION:
                CleanupBastion()
                break
            case Hero.SYMMETRA:
                CleanupSymmetra()
                break
            case Hero.ZENYATTA:
                CleanupZenyatta()
                break
            case Hero.GENJI:
                CleanupGenji()
                break
            case Hero.ROADHOG:
                CleanupRoadhog()
                break
            case Hero.MCCREE:
                CleanupMccree()
                break
            case Hero.JUNKRAT:
                CleanupJunkrat()
                break
            case Hero.ZARYA:
                CleanupZarya()
                break
            case Hero.SOLDIER:
                CleanupSoldier()
                break
            case Hero.LUCIO:
                CleanupLucio()
                break
            case Hero.DVA:
                CleanupDva()
                break
            case Hero.MEI:
                CleanupMei()
                break
            case Hero.SOMBRA:
                CleanupSombra()
                break
            case Hero.DOOMFIST:
                CleanupDoomfist()
                break
            case Hero.ANA:
                CleanupAna()
                break
            case Hero.ORISA:
                CleanupOrisa()
                break
            case Hero.BRIGITTE:
                CleanupBrigitte()
                break
            case Hero.MOIRA:
                CleanupMoira()
                break
            case Hero.HAMMOND:
                CleanupWreckingball()
                break
            case Hero.ASHE:
                CleanupAshe()
                break
            case Hero.ECHO:
                CleanupEcho()
                break
            case Hero.BAPTISTE:
                CleanupBaptiste()
                break
            case Hero.SIGMA:
                CleanupSigma()
                break
            default:
                break

        #Clean Slate will make sure the character is at least playable if anything above fails
        if eventPlayer.getCurrentHero() != Hero.ECHO: #Another singular echo exception
            CleanSlate()

        #Here an initializer subroutine will be called, this should be defined by each developer for their specific hero, called InitialHERO (all hero names are spelled with one Capital then all lowercase)
        eventPlayer.hero = eventPlayer.getCurrentHero()
        
        switch eventPlayer.hero:
            case Hero.REAPER:
                InitialReaper()
                break
            case Hero.TRACER:
                InitialTracer()
                break
            case Hero.MERCY:
                InitialMercy()
                break
            case Hero.HANZO:
                InitialHanzo()
                break
            case Hero.TORBJORN:
                InitialTorbjorn()
                break
            case Hero.REINHARDT:
                InitialReinhardt()
                break
            case Hero.PHARAH:
                InitialPharah()
                break
            case Hero.WINSTON:
                InitialWinston()
                break
            case Hero.WIDOWMAKER:
                InitialWidowmaker()
                break
            case Hero.BASTION:
                InitialBastion()
                break
            case Hero.SYMMETRA:
                InitialSymmetra()
                break
            case Hero.ZENYATTA:
                InitialZenyatta()
                break
            case Hero.GENJI:
                InitialGenji()
                break
            case Hero.ROADHOG:
                InitialRoadhog()
                break
            case Hero.MCCREE:
                InitialMccree()
                break
            case Hero.JUNKRAT:
                InitialJunkrat()
                break
            case Hero.ZARYA:
                InitialZarya()
                break
            case Hero.SOLDIER:
                InitialSoldier()
                break
            case Hero.LUCIO:
                InitialLucio()
                break
            case Hero.DVA:
                InitialDva()
                break
            case Hero.MEI:
                InitialMei()
                break
            case Hero.SOMBRA:
                InitialSombra()
                break
            case Hero.DOOMFIST:
                InitialDoomfist()
                break
            case Hero.ANA:
                InitialAna()
                break
            case Hero.ORISA:
                InitialOrisa()
                break
            case Hero.BRIGITTE:
                InitialBrigitte()
                break
            case Hero.MOIRA:
                InitialMoira()
                break
            case Hero.HAMMOND:
                InitialWreckingball()
                break
            case Hero.ASHE:
                InitialAshe()
                break
            case Hero.ECHO:
                async(InitialEcho, AsyncBehavior.RESTART) #Echo should be the only exception to the rule that initializers and cleanups need to be instant.
                break
            case Hero.BAPTISTE:
                InitialBaptiste()
                break
            case Hero.SIGMA:
                InitialSigma()
                break
            default:
                break
        wait()
    while RULE_CONDITION
