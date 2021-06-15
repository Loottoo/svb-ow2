#!mainFile "../main.opy"


globalvar _extendedGlobalCollection
globalvar _classIndexes
globalvar _objectVariable_0
globalvar _objectVariable_1
globalvar _objectVariable_2
globalvar _objectVariable_3
globalvar _objectVariable_4
globalvar ActiveModifications
globalvar LastMoveSpeedModificationID
globalvar antiCrashActivated
globalvar ForbiddenUltimateHeroes
globalvar ForbiddenAbility1Heroes
globalvar ForbiddenAbility2Heroes
globalvar slot
globalvar c
globalvar cIndex
globalvar c_0
globalvar cIndex_0
globalvar MoveSpeed


#Player variables

playervar _extendedPlayerCollection
playervar SupportHealingID
playervar DamageMoveSpeedID
playervar NextUltCharge
playervar HeroActive
playervar HeroEffects
playervar HeroTexts
playervar HeroHealthPools
playervar HeroDamageModifications
playervar HeroHealingModifications
playervar HeroMoveSpeedModifications
playervar BaptisteMoveSpeedID
playervar EchoLastHealth
playervar ReinhardtFirestrikeCharges
playervar ReinhardtFirestrikeCooldown
playervar facingAngle
playervar CastingUltimate
playervar OrisaMoveSpeedID
playervar Galloping
playervar HealingPercents
playervar DegenerationEnabled
playervar LastMercyTarget
playervar AngelicBlessingPosition
playervar AngelicBlessingTarget
playervar AngelicBlessingFlyTarget
playervar AngelicBlessings
playervar SymmetraBotPlayer
playervar SombraProjectilePosition
playervar SombraSelectedTarget
playervar MusicMeter
playervar WallrideTimer
playervar ZaryaBubbleCharges
playervar ZaryaBubbleCooldown
playervar repeat
playervar frac
playervar frac_0
playervar slot
playervar ExcludedPlayers
playervar TimeRemaining
playervar TargetPlayers
playervar TemporaryCooldown
playervar slot_0
playervar slot_1
playervar AngelicBlessingTextID
playervar AngelicBlessingConfirmID
playervar Superjumping
playervar Direction
playervar repeat_0
playervar hero_0
playervar slot_2
playervar SoundbarrierCalculation
playervar SpeedboostBonus


#Subroutine names

subroutine InitialBaptiste
subroutine CleanupBaptiste
subroutine CleanupEffects
subroutine CleanupHealingMods
subroutine CleanupMoveSpeedMods
subroutine BaptisteCastIF
subroutine SlowdownBaptiste
subroutine ReturnBaptisteToNormalSpeed
subroutine InitialReinhardt
subroutine CleanupReinhardt
subroutine CleanupHealthPools
subroutine CleanupTexts
subroutine ReinhardtChargeCancelling
subroutine ReinhardtLowerChargeCooldown
subroutine ReinhardtRefreshFirestrike
subroutine ReinhardtFirestrikeRecharge
subroutine ReinhardtDetectFacingAngle
subroutine InitialWinston
subroutine CleanupWinston
subroutine InitialWidowmaker
subroutine CleanupWidowmaker
subroutine CleanupDamageMods
subroutine InitialOrisa
subroutine CleanupOrisa
subroutine OrisaDecreaseMovementPenalty
subroutine OrisaGallop
subroutine CreateHeroEffects
subroutine OrisaUltimate
subroutine InitialMercy
subroutine CleanupMercy
subroutine MercyDegenerateBeam
subroutine MercyRegenerateBeam
subroutine MercyUpdateDegeneration
subroutine MercyClearLastTarget
subroutine MercyAngelicBlessing
subroutine MercyAngelicBlessingOutline
subroutine InitialSymmetra
subroutine CleanupSymmetra
subroutine SymmetraLightCloneUlt
subroutine CreateSymmetraBotEffects
subroutine UpdateSymmetraAI
subroutine FlankerSetup
subroutine FlankerCleanup
subroutine InitialSombra
subroutine CleanupSombra
subroutine SombraProjectileHit
subroutine SombraLaunchProjectile
subroutine InitialLucio
subroutine CleanupLucio
subroutine LucioSoundbarrier
subroutine LucioSpeedBoost
subroutine InitialMccree
subroutine CleanupMccree
subroutine InitialZarya
subroutine CleanupZarya
subroutine ZaryaRefreshBubble
subroutine ZaryaBubbleRecharge
subroutine ZaryaBubbleEnable
subroutine ZaryaBubbleDisable


#!extension buffStatusEffects
#!extension buffAndDebuffSounds
#!extension explosionSounds
#!extension spawnMoreDummyBots


rule "Initial Global":
    _classIndexes[1000] = 0
    _classIndexes[0] = -1
    ActiveModifications = []
    LastMoveSpeedModificationID = 0
    antiCrashActivated = false
    ForbiddenUltimateHeroes = [Hero.DOOMFIST, Hero.DVA, Hero.PHARAH, Hero.JUNKRAT]
    ForbiddenAbility1Heroes = [Hero.REINHARDT, Hero.TRACER]
    ForbiddenAbility2Heroes = [Hero.TRACER]


rule "Initial Player":
    @Event eachPlayer
    
    eventPlayer.NextUltCharge = 5
    eventPlayer.HeroActive = null
    eventPlayer.HeroEffects = []
    eventPlayer.HeroTexts = []
    eventPlayer.HeroHealthPools = []
    eventPlayer.HeroDamageModifications = []
    eventPlayer.HeroHealingModifications = []
    eventPlayer.HeroMoveSpeedModifications = []
    eventPlayer.EchoLastHealth = 200
    eventPlayer.ReinhardtFirestrikeCharges = 2
    eventPlayer.ReinhardtFirestrikeCooldown = 6
    eventPlayer.HealingPercents = []
    eventPlayer.DegenerationEnabled = []
    eventPlayer.LastMercyTarget = []
    eventPlayer.AngelicBlessings = []
    eventPlayer.MusicMeter = 0
    eventPlayer.WallrideTimer = 0
    eventPlayer.ZaryaBubbleCharges = 2
    eventPlayer.ZaryaBubbleCooldown = 5


def CleanupEffects():
    @Name "[all.del] Subroutine: Cleanup Effects"
    
    destroyEffect(eventPlayer.HeroEffects)
    eventPlayer.HeroEffects = []


def CleanupHealingMods():
    @Name "[all.del] Subroutine: Cleanup Healing Modifications"
    
    eventPlayer._extendedPlayerCollection[4] = 0
    while eventPlayer._extendedPlayerCollection[4] < len(eventPlayer.HeroHealingModifications):
        stopHealingModification(eventPlayer.HeroHealingModifications[eventPlayer._extendedPlayerCollection[4]])
        eventPlayer._extendedPlayerCollection[4] += 1
    eventPlayer.HeroHealingModifications = []


def CleanupMoveSpeedMods():
    @Name "[all.del] Subroutine: Cleanup Move Speed Modifications"
    
    eventPlayer._extendedPlayerCollection[5] = 0
    while eventPlayer._extendedPlayerCollection[5] < len(eventPlayer.HeroMoveSpeedModifications):
        eventPlayer._extendedPlayerCollection[6] = 0
        while eventPlayer._extendedPlayerCollection[6] < len([].concat(eventPlayer)):
            ActiveModifications.remove(([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.HeroMoveSpeedModifications[eventPlayer._extendedPlayerCollection[5]]])[0])
            eventPlayer._extendedPlayerCollection[6] += 1
        eventPlayer._extendedPlayerCollection[5] += 1
    eventPlayer.HeroMoveSpeedModifications = []


def CleanupHealthPools():
    @Name "[all.del] Subroutine: Cleanup Health Pool"
    
    eventPlayer._extendedPlayerCollection[7] = 0
    while eventPlayer._extendedPlayerCollection[7] < len(eventPlayer.HeroHealthPools):
        removeHealthPool(eventPlayer.HeroHealthPools[eventPlayer._extendedPlayerCollection[7]])
        eventPlayer._extendedPlayerCollection[7] += 1
    eventPlayer.HeroHealthPools = []


def CleanupTexts():
    @Name "[all.del] Subroutine: Cleanup Texts"
    
    eventPlayer._extendedPlayerCollection[8] = 0
    while eventPlayer._extendedPlayerCollection[8] < len(eventPlayer.HeroTexts):
        destroyHudText(eventPlayer.HeroTexts[eventPlayer._extendedPlayerCollection[8]])
        destroyInWorldText(eventPlayer.HeroTexts[eventPlayer._extendedPlayerCollection[8]])
        destroyProgressBarHud(eventPlayer.HeroTexts[eventPlayer._extendedPlayerCollection[8]])
        eventPlayer._extendedPlayerCollection[8] += 1
    eventPlayer.HeroTexts = []


def CleanupDamageMods():
    @Name "[all.del] Subroutine: Cleanup Damage Modifications"
    
    eventPlayer._extendedPlayerCollection[9] = 0
    while eventPlayer._extendedPlayerCollection[9] < len(eventPlayer.HeroDamageModifications):
        stopDamageModification(eventPlayer.HeroDamageModifications[eventPlayer._extendedPlayerCollection[9]])
        eventPlayer._extendedPlayerCollection[9] += 1
    eventPlayer.HeroDamageModifications = []


def FlankerCleanup():
    @Name "[flanker.del] Subroutine: Cleanup"
    
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    CleanupMoveSpeedMods()
    wait()
    eventPlayer.HeroActive = null


def FlankerSetup():
    @Name "[flanker.del] Subroutine: Setup"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == eventPlayer.hero:
        return
    wait()
    eventPlayer.HeroActive = eventPlayer.hero
    eventPlayer._extendedPlayerCollection[12] = 0
    while eventPlayer._extendedPlayerCollection[12] < len([].concat(eventPlayer)):
        LastMoveSpeedModificationID += 1
        eventPlayer._extendedPlayerCollection[13] = _classIndexes.index(0)
        _classIndexes[eventPlayer._extendedPlayerCollection[13]] = 8
        _objectVariable_3[eventPlayer._extendedPlayerCollection[13]] = []
        _objectVariable_4[eventPlayer._extendedPlayerCollection[13]] = 0
        _objectVariable_1[eventPlayer._extendedPlayerCollection[13]] = [].concat(eventPlayer)[eventPlayer._extendedPlayerCollection[12]]
        _objectVariable_0[eventPlayer._extendedPlayerCollection[13]] = LastMoveSpeedModificationID
        _objectVariable_2[eventPlayer._extendedPlayerCollection[13]] = 91.709
        ActiveModifications.append(eventPlayer._extendedPlayerCollection[13])
        eventPlayer._extendedPlayerCollection[12] += 1
    eventPlayer.HeroMoveSpeedModifications.append(LastMoveSpeedModificationID)
    eventPlayer.hero_0 = eventPlayer.hero
    async(FlankerCleanup, AsyncBehavior.NOOP)


rule "[flanker.del] Initial Tracer":
    @Event eachPlayer
    @Hero tracer
    FlankerSetup()


rule "[flanker.del] Initial Genji":
    @Event eachPlayer
    @Hero genji
    FlankerSetup()


rule "[flanker.del] Initial Tracer (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.TRACER
    FlankerSetup()


rule "[flanker.del] Initial Genji (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.GENJI
    FlankerSetup()
