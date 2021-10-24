#!mainFile "../../main.opy"

subroutine CancelDuplicate

def CancelDuplicate():
    @Name "Echo Return"

    stopChasingVariable(eventPlayer.DuplicateFacing)
    stopChasingVariable(eventPlayer.DuplicatePassiveCharge)
    eventPlayer.DuplicateVals[0] = 0
    eventPlayer.DuplicateTimer = 0
    eventPlayer.startForcingHero(Hero.ECHO)
    eventPlayer.stopForcingCurrentHero()
    destroyEffect(eventPlayer.DuplicateVals[2])
    eventPlayer.stopModifyingVoicelinePitch()
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 0.6)
    wait()
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 120)
    eventPlayer.setFacing(eventPlayer.DuplicateFacing, Relativity.TO_WORLD)
    eventPlayer.setHealth(eventPlayer.DuplicateVals[1])
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0.6, 0, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(-0.6, 0, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0, 0, 0.6), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0, 0, -0.6), 1)
    wait(0.112)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0.6, 0, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(-0.6, 0, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0, 0, 0.6), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0, 0, -0.6), 1)
    wait(0.112)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0.6, 0, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(-0.6, 0, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0, 0, 0.6), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0, 0, -0.6), 1)
    wait(0.112)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0.6, 0, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(-0.6, 0, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0, 0, 0.6), 1)
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.getPosition() + vect(0, 0, -0.6), 1)
    wait(0.298)




rule "Echo Duplicate Save Return Health":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getUltCharge() == 0
    @Condition eventPlayer.DuplicateTimer == 0
    @Condition eventPlayer.getHeroOfDuplication() == false

    wait(0.32)
    eventPlayer.DuplicateVals[1] = max(100, eventPlayer.getHealth())


rule "Echo Cast Duplicate":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == true

    eventPlayer.preloadHero(eventPlayer.getHeroOfDuplication())
    wait(0.634)
    eventPlayer.startModifyingVoicelinePitch(1.25, false)
    createEffect(getAllPlayers(), Effect.ECHO_CLONING, eventPlayer.getTeam(), eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.DuplicateVals[2] = [getLastCreatedEntity()]
    createEffect(getAllPlayers(), Effect.ECHO_CLONING_SOUND, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getPosition()), (180 if localPlayer == eventPlayer else 110) if eventPlayer.getTeam() == localPlayer.getTeam() else 180, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.DuplicateVals[2] = eventPlayer.DuplicateVals[2].concat(getLastCreatedEntity())
    eventPlayer.DuplicateTimer = 15.016
    wait()
    chase(eventPlayer.DuplicateTimer, 0, rate=1, ChaseReeval.NONE)
    eventPlayer.DuplicateVals[0] = 0
    eventPlayer.DuplicatePassiveCharge = 0
    chase(eventPlayer.DuplicatePassiveCharge, 1000, rate=(0 if eventPlayer.isUsingUltimate() else 5), ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.startForcingHero(eventPlayer.getHeroOfDuplication())


rule "Echo Duplicate Expires Naturally":
    @Event eachPlayer
    @Condition eventPlayer.DuplicateTimer != 0

    eventPlayer.DuplicateFacing = eventPlayer.getFacingDirection()
    wait()
    eventPlayer.setFacing(eventPlayer.DuplicateFacing, Relativity.TO_WORLD)
    chase(eventPlayer.DuplicateFacing, updateEveryTick(eventPlayer.getFacingDirection()), rate=1000, ChaseReeval.DESTINATION_AND_RATE)
    wait(0.6)
    eventPlayer.communicate(Comms.VOICE_LINE_UP)
    eventPlayer.preloadHero(Hero.ECHO)
    waitUntil(eventPlayer.DuplicateTimer < 4.6, 99999)
    playEffect(eventPlayer, DynamicEffect.SOMBRA_LOGO_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(eventPlayer, DynamicEffect.ANA_BIOTIC_GRENADE_INCREASED_HEALING_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(eventPlayer, DynamicEffect.ANA_SLEEPING_SOUND, Color.WHITE, eventPlayer, 70)
    #waitUntil(eventPlayer.DuplicateTimer < 3, 99999)
    #playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 90)
    #waitUntil(eventPlayer.DuplicateTimer < 2, 99999)
    #playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 115)
    #waitUntil(eventPlayer.DuplicateTimer < 1, 99999)
    #playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 140)
    waitUntil(eventPlayer.DuplicateTimer == 0, 99999)
    async(CancelDuplicate, AsyncBehavior.NOOP)


rule "Echo Duplicate Death Respawns Echo":
    @Event playerDied
    @Condition eventPlayer.DuplicateTimer == true

    async(CancelDuplicate, AsyncBehavior.NOOP)



rule "Echo Duplicate Ultimate Generation":
    @Event eachPlayer
    @Condition (eventPlayer.getUltCharge() != eventPlayer.DuplicateVals[0] or eventPlayer.DuplicatePassiveCharge / UltChargeReqArray[getAllHeroes().index(eventPlayer.getCurrentHero())] >= 0.002) == true
    @Condition eventPlayer.DuplicateTimer < 15
    @Condition eventPlayer.DuplicateTimer != 0

    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + ((eventPlayer.getUltCharge() - eventPlayer.DuplicateVals[0]) * 4))
    if eventPlayer.DuplicatePassiveCharge / UltChargeReqArray[getAllHeroes().index(eventPlayer.getCurrentHero())] >= 0.002:
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 1)
        eventPlayer.DuplicatePassiveCharge -= UltChargeReqArray[getAllHeroes().index(eventPlayer.getCurrentHero())] * 0.002
    wait()
    eventPlayer.DuplicateVals[0] = eventPlayer.getUltCharge()
    if RULE_CONDITION:
        goto RULE_START
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "Echo Duplicate Reset Ultimate Generation":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getUltCharge() == 0
    @Condition eventPlayer.DuplicateTimer < 15
    @Condition eventPlayer.DuplicateTimer != 0

    eventPlayer.DuplicateVals[0] = 0


rule "Echo Duplicate Dva Bugfix 1":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.DuplicateTimer != 0

    destroyEffect(eventPlayer.DuplicateVals[2])
    eventPlayer.DuplicateVals[2] = []
    createEffect(getAllPlayers(), Effect.ECHO_CLONING, eventPlayer.getTeam(), eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.DuplicateVals[2] = eventPlayer.DuplicateVals[2].concat(getLastCreatedEntity())
    createEffect(getAllPlayers(), Effect.ECHO_CLONING_SOUND, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getPosition()), (180 if localPlayer == eventPlayer else 110) if eventPlayer.getTeam() == localPlayer.getTeam() else 180, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.DuplicateVals[2] = eventPlayer.DuplicateVals[2].concat(getLastCreatedEntity())


rule "Echo Duplicate Dva Bugfix 2":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == false
    @Condition eventPlayer.DuplicateTimer != 0

    if eventPlayer.DuplicateTimer > 14.5:
        return
    destroyEffect(eventPlayer.DuplicateVals[2])
    eventPlayer.DuplicateVals[2] = []
    createEffect(getAllPlayers(), Effect.ECHO_CLONING, eventPlayer.getTeam(), eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.DuplicateVals[2] = eventPlayer.DuplicateVals[2].concat(getLastCreatedEntity())
    createEffect(getAllPlayers(), Effect.ECHO_CLONING_SOUND, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getPosition()), (180 if localPlayer == eventPlayer else 110) if eventPlayer.getTeam() == localPlayer.getTeam() else 180, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.DuplicateVals[2] = eventPlayer.DuplicateVals[2].concat(getLastCreatedEntity())

rule "Prevent teammates from picking Echo while dupeing":
    @Event eachPlayer
    #Not an echo at heart
    @Condition (eventPlayer.DuplicateTimer > 0 or eventPlayer.hero == Hero.ECHO) == false
    #And an echo is actively dupeing (away from home)
    @Condition any([p.DuplicateTimer > 0 for p in getPlayers(eventPlayer.getTeam())])
    #And echo can be picked by this player
    @Condition Hero.ECHO in eventPlayer.getAllowedHeroes()

    #Disallow Echo pick
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(Hero.ECHO))
    #Wait until we know no one is dupeing
    waitUntil(all([p.DuplicateTimer == 0 for p in getPlayers(eventPlayer.getTeam())]), 9999)
    #Reset hero availability
    eventPlayer.setAllowedHeroes(allowedHeroes(eventPlayer))
