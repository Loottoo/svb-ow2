#!mainFile "../../main.opy"

globalvar SigmaSecondaryOptions


playervar Flight
playervar FlightSound
playervar SigmaSecondary
playervar SigmaSecondaryTimer
playervar SigmaLifted




rule "Global Sigma Config Init":
    #Indices: 0 = duration, 1 = cooldown, 2 = radius, 3 = height
    SigmaSecondaryOptions = []
    SigmaSecondaryOptions[0] = createWorkshopSetting(float[3:20], "Sigma", "Gravitic Lift duration", 8, 0)
    SigmaSecondaryOptions[1] = createWorkshopSetting(float[3:30], "Sigma", "Gravitic Lift cooldown (can't place another until the first expires)", 13, 1)
    SigmaSecondaryOptions[2] = createWorkshopSetting(float[1.25:8], "Sigma", "Gravitic Lift radius", 3.5, 2)
    SigmaSecondaryOptions[3] = createWorkshopSetting(float[5:40], "Sigma", "Gravitic Lift height", 25, 3)


def InitialSigma():

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.addHealthPool(Health.SHIELDS, 50, true, false)


def CleanupSigma():

    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.allowButton(Button.ULTIMATE)
    if eventPlayer.SigmaSecondary[1]:
        destroyEffect(eventPlayer.SigmaSecondary[1])
        eventPlayer.SigmaSecondary[1] = false
    stopChasingVariable(eventPlayer.SigmaSecondaryTimer)
    eventPlayer.SigmaSecondaryTimer = 0


rule "Sigma Secondary":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition (not (eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.STUNNED))) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isUsingAbility2() == false
    @Condition eventPlayer.isUsingUltimate() == false

    stopChasingVariable(eventPlayer.SigmaSecondaryTimer)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.SigmaSecondary = []
    createEffect(updateEveryTick([i for i in eventPlayer if raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, null, false).getHitPosition() != eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15]), Effect.RING, eventPlayer.getTeam(), updateEveryTick(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, null, false).getHitPosition()), SigmaSecondaryOptions[2], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SigmaSecondary[1] = [getLastCreatedEntity()]
    createEffect(updateEveryTick([i for i in eventPlayer if raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, null, false).getHitPosition() != eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15]), Effect.ORB, eventPlayer.getTeam(), updateEveryTick(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, null, false).getHitPosition()), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SigmaSecondary[1] = eventPlayer.SigmaSecondary[1].concat(getLastCreatedEntity())
    createEffect(updateEveryTick([i for i in eventPlayer if raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, null, false).getHitPosition() == eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15]), Effect.SPHERE, eventPlayer.getTeam(), updateEveryTick(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, null, false).getHitPosition()), 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SigmaSecondary[1] = eventPlayer.SigmaSecondary[1].concat(getLastCreatedEntity())
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 99999)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.allowButton(Button.ULTIMATE)
    destroyEffect(eventPlayer.SigmaSecondary[1])
    if raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, null, false).getHitPosition() == eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15:
        return
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, SigmaSecondaryOptions[1])
    eventPlayer.SigmaSecondary[0] = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, null, false).getHitPosition()
    createEffect(getAllPlayers(), Effect.RING, eventPlayer.getTeam(), eventPlayer.SigmaSecondary[0], SigmaSecondaryOptions[2], EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SigmaSecondary[1] = [getLastCreatedEntity()]
    eventPlayer.SigmaSecondary[2] = true
    eventPlayer.SigmaSecondaryTimer = 1
    createBeam(getAllPlayers(), Beam.BAD, eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(0), -1 * eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else -1 * SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(0.1))), eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(0), eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(0))), eventPlayer.getTeam(), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SigmaSecondary[1] = eventPlayer.SigmaSecondary[1].concat(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.BAD, eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(60), -1 * eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else -1 * SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(60))), eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(60), eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(60))), eventPlayer.getTeam(), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SigmaSecondary[1] = eventPlayer.SigmaSecondary[1].concat(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.BAD, eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(120), -1 * eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else -1 * SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(120))), eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(120), eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(120))), eventPlayer.getTeam(), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SigmaSecondary[1] = eventPlayer.SigmaSecondary[1].concat(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.BAD, eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(180), -1 * eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else -1 * SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(0))), eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(180), eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * 0)), eventPlayer.getTeam(), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SigmaSecondary[1] = eventPlayer.SigmaSecondary[1].concat(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.BAD, eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(240), -1 * eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else -1 * SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(240))), eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(240), eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(240))), eventPlayer.getTeam(), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SigmaSecondary[1] = eventPlayer.SigmaSecondary[1].concat(getLastCreatedEntity())
    createBeam(getAllPlayers(), Beam.BAD, eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(300), -1 * eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else -1 * SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(300))), eventPlayer.SigmaSecondary[0] + (vect(SigmaSecondaryOptions[2] * cosDeg(300), eventPlayer.SigmaSecondaryTimer if eventPlayer.SigmaSecondary[2] else SigmaSecondaryOptions[3], SigmaSecondaryOptions[2] * sinDeg(300))), eventPlayer.getTeam(), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SigmaSecondary[1] = eventPlayer.SigmaSecondary[1].concat(getLastCreatedEntity())
    eventPlayer.communicate(Comms.GO)
    while eventPlayer.SigmaSecondaryTimer < SigmaSecondaryOptions[3]:
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.getTeam(), eventPlayer.SigmaSecondary[0] + vect(0, eventPlayer.SigmaSecondaryTimer, 0), SigmaSecondaryOptions[2] * 2)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.getTeam(), eventPlayer.SigmaSecondary[0] + vect(0, -1 * eventPlayer.SigmaSecondaryTimer, 0), SigmaSecondaryOptions[2] * 2)
        eventPlayer.SigmaSecondaryTimer += 2 * SigmaSecondaryOptions[3] / 25
        wait(0.08)
    eventPlayer.SigmaSecondary[2] = false
    eventPlayer.SigmaSecondaryTimer = SigmaSecondaryOptions[0] - 0.9
    chase(eventPlayer.SigmaSecondaryTimer, 1.2, rate=1, ChaseReeval.NONE)
    waitUntil(eventPlayer.SigmaSecondaryTimer == 1.2, 99999)
    stopChasingVariable(eventPlayer.SigmaSecondaryTimer)
    eventPlayer.SigmaSecondaryTimer = SigmaSecondaryOptions[3]
    eventPlayer.SigmaSecondary[2] = true
    while eventPlayer.SigmaSecondaryTimer > 1:
        eventPlayer.SigmaSecondaryTimer -= 2 * SigmaSecondaryOptions[3] / 25
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.getTeam(), eventPlayer.SigmaSecondary[0] + vect(0, eventPlayer.SigmaSecondaryTimer, 0), SigmaSecondaryOptions[2] * 2)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.getTeam(), eventPlayer.SigmaSecondary[0] + vect(0, -1 * eventPlayer.SigmaSecondaryTimer, 0), SigmaSecondaryOptions[2] * 2)
        wait(0.112)
    eventPlayer.SigmaSecondaryTimer = 0
    destroyEffect(eventPlayer.SigmaSecondary[1])
    eventPlayer.SigmaSecondary[1] = false


rule "Each Player, Check for Affected By Sigma Secondary":
    @Event eachPlayer
    @Condition [player for player in getPlayersOnHero(Hero.SIGMA, eventPlayer.getTeam()) if player.SigmaSecondaryTimer == true] != []

    waitUntil([player for player in getPlayersOnHero(Hero.SIGMA, eventPlayer.getTeam()) if player.SigmaSecondaryTimer == true] == [] or ([player for player in getPlayersOnHero(Hero.SIGMA, eventPlayer.getTeam()) if player.SigmaSecondaryTimer == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), player.SigmaSecondary[0] * vect(1, 0, 1)) <= SigmaSecondaryOptions[2] and distance(eventPlayer.getPosition() * vect(0, 1, 0), player.SigmaSecondary[0] * vect(0, 1, 0)) <= SigmaSecondaryOptions[3]]) != [], 99999)
    eventPlayer.Flight = true
    waitUntil([player for player in getPlayersOnHero(Hero.SIGMA, eventPlayer.getTeam()) if player.SigmaSecondaryTimer == true] == [] or ([player for player in getPlayersOnHero(Hero.SIGMA, eventPlayer.getTeam()) if player.SigmaSecondaryTimer == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), player.SigmaSecondary[0] * vect(1, 0, 1)) <= SigmaSecondaryOptions[2] and distance(eventPlayer.getPosition() * vect(0, 1, 0), player.SigmaSecondary[0] * vect(0, 1, 0)) <= SigmaSecondaryOptions[3]]) == [], 99999)
    eventPlayer.Flight = false
    if RULE_CONDITION:
        goto RULE_START


rule "Flight Mechanic":
    @Event eachPlayer
    @Condition eventPlayer.Flight == true
    #@Condition eventPlayer.hasStatusEffect(Status.ROOTED) == false
    @Condition eventPlayer.isAlive() == true
    @Condition not (eventPlayer.hero == Hero.DOOMFIST and eventPlayer.isUsingAbility2())

    eventPlayer.setGravity(0)
    createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET_SOUND, eventPlayer.getTeam(), eventPlayer, 60, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.FlightSound = getLastCreatedEntity()
    while eventPlayer.Flight and eventPlayer.isAlive() and not (eventPlayer.hero == Hero.DOOMFIST and eventPlayer.isUsingAbility2()):
        if (eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isHoldingButton(Button.JUMP)) and (not (eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.isHoldingButton(Button.JUMP))):
            if eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.ROOTED) or eventPlayer.hasStatusEffect(Status.STUNNED):
                goto lbl_0
            eventPlayer.applyImpulse(vect(0, (1 if eventPlayer.isHoldingButton(Button.JUMP) else 0) - (1 if eventPlayer.isHoldingButton(Button.CROUCH) else 0), 0), max((min(5.5 - (eventPlayer.getSpeedInDirection(vect(0, (1 if eventPlayer.isHoldingButton(Button.JUMP) else 0) - (1 if eventPlayer.isHoldingButton(Button.CROUCH) else 0), 0))), 11)) * (0.065 if eventPlayer.getThrottle() == vect(0, 0, 0) else 0.024), 0), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            lbl_0:
            eventPlayer.applyImpulse(eventPlayer.getVelocity() * vect(0, 1, 0), abs(eventPlayer.getVerticalSpeed()) * -0.05 + -0.015, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        if eventPlayer.getThrottle() != vect(0, 0, 0):
            if eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.ROOTED) or eventPlayer.hasStatusEffect(Status.STUNNED):
                goto lbl_1
            eventPlayer.applyImpulse(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION), (min(max(5.5 - eventPlayer.getSpeedInDirection(worldVector(eventPlayer.getThrottle(), eventPlayer, Transform.ROTATION)), 0), 3)) * 0.225, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            lbl_1:
            eventPlayer.applyImpulse(eventPlayer.getVelocity() * vect(1, 0, 1), eventPlayer.getHorizontalSpeed() * -0.055 + -0.015, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    eventPlayer.setGravity(100)
    destroyEffect(eventPlayer.FlightSound)
    eventPlayer.FlightSound = false


rule "Sigma Damage Adjustments":
    @Event playerDealtDamage
    @Hero sigma

    if victim == eventPlayer:
        return
    if eventAbility == Button.PRIMARY_FIRE:
        damage(victim, eventPlayer, 10 if victim.getHealthOfType(Health.ARMOR) else 5)
    if eventAbility == Button.ABILITY_2:
        damage(victim, eventPlayer, 15 if victim.getHealthOfType(Health.ARMOR) else 10)
    if eventAbility == Button.ULTIMATE:
        victim.SigmaLifted = false


rule "Detect Sigma Lift via Knockback Event":
    @Event playerDealtKnockback
    @Hero sigma
    @Condition eventAbility == Button.ULTIMATE

    victim.SigmaLifted = eventPlayer


rule "Lifted By Sigma (Used to disable cancelling)":
    @Event eachPlayer
    @Condition eventPlayer.SigmaLifted == true

    waitUntil(not getPlayersOnHero(Hero.SIGMA, getOppositeTeam(eventPlayer.getTeam())).isUsingUltimate() or eventPlayer.hasStatusEffect(Status.PHASED_OUT), 2.016)
    if eventPlayer.SigmaLifted.isUsingUltimate():
        waitUntil(not eventPlayer.SigmaLifted, 1.5)
        eventPlayer.SigmaLifted = false
        return
    if not eventPlayer.SigmaLifted:
        return
    eventPlayer.applyImpulse(Vector.UP, 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.5)
    if not eventPlayer.SigmaLifted:
        return
    eventPlayer.applyImpulse(Vector.DOWN, 15, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.18)
    if not eventPlayer.SigmaLifted:
        return
    eventPlayer.applyImpulse(Vector.DOWN, 50, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    waitUntil(eventPlayer.isOnGround(), 99999)
    if not eventPlayer.SigmaLifted:
        return
    eventPlayer.SigmaLifted.setUltEnabled(false)
    damage(eventPlayer, eventPlayer.SigmaLifted, eventPlayer.getMaxHealth() / 2)
    eventPlayer.SigmaLifted.setUltEnabled(true)
    eventPlayer.setStatusEffect(eventPlayer.SigmaLifted, Status.ROOTED, 0.5)
    eventPlayer.SigmaLifted = false


