#!mainFile "../../main.opy"


globalvar orisaGallopDuration = createWorkshopSetting(float[0.1:2], "Orisa", "Time gallop duration", 0.5, 0)
globalvar orisaGallopDelay = createWorkshopSetting(float[0:2], "Orisa", "Gallop cast time", 0.3, 1)
globalvar orisaGallopDamage = createWorkshopSetting(int[0:200], "Orisa", "Time gallop damage dealt", 50, 2)


def CreateHeroEffects():
    @Name "[orisa.del] Subroutine: Create Effects"
    
    createEffect(getPlayers(eventPlayer.getTeam()), Effect.GOOD_AURA, Color.LIME_GREEN, updateEveryTick(eventPlayer.getEyePosition()), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    createEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())), Effect.GOOD_AURA, Color.RED, updateEveryTick(eventPlayer.getEyePosition()), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    createEffect(getAllPlayers(), Effect.WINSTON_PRIMAL_RAGE, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getEyePosition()), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    createEffect(getAllPlayers(), Effect.ENERGY_SOUND, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getEyePosition()), 500, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())


def OrisaGallop():
    @Name "[orisa.del] Subroutine: Gallop"
    
    if eventPlayer.CastingUltimate:
        return
    if eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0:
        return
    if eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.STUNNED) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.isDead():
        return
    #Communication
    eventPlayer.setDamageDealt(0)
    eventPlayer.forceButtonPress(Button.MELEE)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setAbilityCooldown(Button.MELEE, 0)
    #Disable
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.disallowButton(Button.ULTIMATE)
    #Start transition to third person camera
    eventPlayer.startCamera(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection(), 30)
    wait()
    eventPlayer.startCamera(raycast(worldVector(vect(0, 0, 0), eventPlayer, Transform.ROTATION_AND_TRANSLATION), worldVector(vect(0, 3, -2), eventPlayer, Transform.ROTATION_AND_TRANSLATION), getAllPlayers(), eventPlayer, true).getHitPosition(), worldVector(vect(0, 3, 0), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 30)
    async(CreateHeroEffects, AsyncBehavior.NOOP)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, eventPlayer.getTeam(), eventPlayer.getEyePosition(), 500)
    playEffect(getAllPlayers(), DynamicEffect.ORISA_HALT_IMPLOSION_SOUND, eventPlayer.getTeam(), eventPlayer.getEyePosition(), 500)
    #Casting
    _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.OrisaMoveSpeedID])[0]] = 0
    eventPlayer.setMoveSpeed(0)
    eventPlayer.startFacing(vect(0, 0, 1), 500, Relativity.TO_PLAYER, FacingReeval.DIRECTION_AND_TURN_RATE)
    waitUntil(any([i == true for i in [eventPlayer.hasStatusEffect(Status.ASLEEP), eventPlayer.hasStatusEffect(Status.HACKED), eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN), eventPlayer.hasStatusEffect(Status.STUNNED), eventPlayer.hasStatusEffect(Status.FROZEN)]]), orisaGallopDelay)
    eventPlayer.setDamageDealt(100)
    #Gallop
    eventPlayer.startForcingThrottle(1, 1, 0, 0, 0, 0)
    _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.OrisaMoveSpeedID])[0]] = 500
    eventPlayer.setMoveSpeed(500)
    eventPlayer.disablePlayerCollision()
    eventPlayer.forceButtonPress(Button.MELEE)
    eventPlayer.Galloping = true
    eventPlayer.ExcludedPlayers = []
    eventPlayer.TimeRemaining = 0
    chase(eventPlayer.TimeRemaining, 9999, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    while eventPlayer.TimeRemaining < orisaGallopDuration:
        if any([i == true for i in [not isInLoS(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(Vector.FORWARD * 2, eventPlayer, Transform.ROTATION), BarrierLos.PASS_THROUGH_BARRIERS), eventPlayer.hasStatusEffect(Status.ASLEEP), eventPlayer.hasStatusEffect(Status.HACKED), eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN), eventPlayer.hasStatusEffect(Status.STUNNED), eventPlayer.hasStatusEffect(Status.FROZEN)]]):
            #Stop Gallop
            break
        else:
            eventPlayer.TargetPlayers = [player for player in getPlayersInRadius(eventPlayer.getEyePosition(), 5, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) if eventPlayer.isInViewAngle(player.getEyePosition(), 90)].exclude(eventPlayer.ExcludedPlayers)
            damage(eventPlayer.TargetPlayers, eventPlayer, orisaGallopDamage)
            eventPlayer.ExcludedPlayers.append(eventPlayer.TargetPlayers)
        wait()
    stopChasingVariable(eventPlayer.TimeRemaining)
    CleanupEffects()
    #Stop movement
    eventPlayer.stopForcingThrottle()
    _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.OrisaMoveSpeedID])[0]] = 0
    eventPlayer.setMoveSpeed(0)
    eventPlayer.enablePlayerCollision()
    eventPlayer.setAbilityCooldown(Button.MELEE, 0)
    eventPlayer.Galloping = false
    wait(0.4)
    #Start transition into first person camera
    eventPlayer.startCamera(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection(), 30)
    wait(0.25)
    eventPlayer.stopCamera()
    #Set cooldown / restore movement
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)
    _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.OrisaMoveSpeedID])[0]] = 100
    eventPlayer.setMoveSpeed(100)
    eventPlayer.stopFacing()
    #Re-enable
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.allowButton(Button.ULTIMATE)


rule "[orisa.del] Gallop":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    OrisaGallop()


rule "[orisa.del] Gallop (Duplicate)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.ORISA
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    OrisaGallop()


def OrisaGallopKnockback():
    @Name "[orisa.del] Subroutine: Galloping Knockback"
    
    victim.applyImpulse(eventDirection + Vector.UP / 2, 20, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setEnvironmentalKillCreditor(attacker)


rule "[orisa.del] Galloping Knockback":
    @Event playerTookDamage
    @Condition (attacker.getCurrentHero() == Hero.ORISA or attacker.getHeroOfDuplication() == Hero.ORISA) == true
    @Condition attacker.Galloping == true
    @Condition eventAbility == null
    
    OrisaGallopKnockback()
