#!mainFile "../main.opy"


globalvar _extendedGlobalCollection
globalvar _classIndexes
globalvar _objectVariable_0
globalvar _objectVariable_1
globalvar _objectVariable_2
globalvar _objectVariable_3
globalvar _objectVariable_4
globalvar ActiveModifications
globalvar antiCrashActivated
globalvar ForbiddenUltimateHeroes
globalvar ForbiddenAbility1Heroes
globalvar ForbiddenAbility2Heroes
globalvar UltChargeReqArray

#Player variables

playervar _extendedPlayerCollection
playervar SupportHealingID
playervar NextUltCharge
playervar HeroEffects
playervar HeroTexts
playervar HeroHealthPools
playervar HeroDamageModifications
playervar HeroHealingModifications
playervar EchoLastHealth
playervar ReinhardtFirestrikeCharges
playervar ReinhardtFirestrikeCooldown
playervar CastingUltimate
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
playervar frac
playervar frac_0
playervar ExcludedPlayers
playervar TimeRemaining
playervar TargetPlayers
playervar TemporaryCooldown
playervar AngelicBlessingTextID
playervar AngelicBlessingConfirmID
playervar Superjumping
playervar Direction
playervar SoundbarrierCalculation
playervar SpeedboostBonus
playervar Index
playervar DuplicateTimer
playervar DuplicateFacing
playervar DuplicateVals
playervar DuplicatePassiveCharge
playervar roadhogCloudEntity
playervar _ActiveSpeedMod
playervar MultSpeedMod
playervar AddSpeedMod
playervar HeroAbsoluteSpeedMod
playervar LucioBoost


#Subroutine names


#subroutines CleanupHERO declared in resets
#subroutines CleanSlate declared in resets
#subroutines InitialHERO declared in resets


#subroutine InitialBaptiste
#subroutine CleanupBaptiste
subroutine CleanupEffects
subroutine CleanupHealingMods
subroutine SlowdownBaptiste
subroutine ReturnBaptisteToNormalSpeed
#subroutine InitialReinhardt
#subroutine CleanupReinhardt
subroutine CleanupHealthPools
subroutine CleanupTexts
#subroutine InitialWinston
#subroutine CleanupWinston
#subroutine InitialWidowmaker
#subroutine CleanupWidowmaker
subroutine CleanupDamageMods
#subroutine InitialOrisa
#subroutine CleanupOrisa
#subroutine InitialMercy
#subroutine CleanupMercy
#subroutine InitialSymmetra
#subroutine CleanupSymmetra
#subroutine InitialSombra
#subroutine CleanupSombra
#subroutine InitialLucio
#subroutine CleanupLucio
#subroutine InitialMccree
#subroutine CleanupMccree
#subroutine InitialZarya
#subroutine CleanupZaryaZ


#!extension buffStatusEffects
#!extension buffAndDebuffSounds
#!extension explosionSounds
#!extension spawnMoreDummyBots


rule "Initial Global":
    _classIndexes[1000] = 0
    _classIndexes[0] = -1
    ActiveModifications = []
    antiCrashActivated = false
    ForbiddenUltimateHeroes = [Hero.DOOMFIST, Hero.DVA, Hero.PHARAH, Hero.JUNKRAT]
    ForbiddenAbility1Heroes = [Hero.REINHARDT, Hero.TRACER]
    ForbiddenAbility2Heroes = [Hero.TRACER]
    UltChargeReqArray = [2100, 1260, 1820, 1680, 2142, 1540, 2100, 1540, 1540, 2310, 1680, 2310, 1932, 1800, 1680, 1925, 2100, 2310, 2940, 1540, 1610, 1400, 1680, 2100, 1680, 2800, 2380, 1540, 2240, 1960, 2310, 1960]
    progressBarHud(localPlayer if localPlayer.DuplicateTimer and localPlayer.isAlive() else null, localPlayer.DuplicateTimer * (100 / 15), "Duplicating: {0}".format(15 if localPlayer.DuplicateTimer > 15 else ceil(localPlayer.DuplicateTimer)), HudPosition.TOP, 3, Color.ORANGE, Color.WHITE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)

    if devMode:
        hudSubheader(localPlayer, "HeroSpeedMod: {0}".format(localPlayer.HeroAbsoluteSpeedMod), HudPosition.TOP, 5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Initial Player":
    @Event eachPlayer

    eventPlayer.NextUltCharge = 5
    eventPlayer.HeroEffects = []
    eventPlayer.HeroTexts = []
    eventPlayer.HeroHealthPools = []
    eventPlayer.HeroDamageModifications = []
    eventPlayer.HeroHealingModifications = []
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
    eventPlayer.roadhogCloudEntity = []
    eventPlayer.MultSpeedMod = 1
    eventPlayer.HeroAbsoluteSpeedMod = 100
    eventPlayer.AddSpeedMod = 0


rule "Speed Modifications Setter":
    @Event eachPlayer
    @Condition eventPlayer._ActiveSpeedMod != (eventPlayer.MultSpeedMod * 100 + eventPlayer.AddSpeedMod) * (eventPlayer.HeroAbsoluteSpeedMod / 100)

    eventPlayer._ActiveSpeedMod = (eventPlayer.MultSpeedMod * 100 + eventPlayer.AddSpeedMod) * (eventPlayer.HeroAbsoluteSpeedMod / 100)
    eventPlayer.setMoveSpeed(eventPlayer._ActiveSpeedMod)
    if RULE_CONDITION:
        goto RULE_START
    wait()
    if RULE_CONDITION:
        goto RULE_START



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
