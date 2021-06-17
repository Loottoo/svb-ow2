#!mainFile "../../main.opy"


globalvar symmetraCloneDamageDealt = createWorkshopSetting(int[0:200], "Symmetra", "Light Clone damage dealt percentage", 100, 0)
globalvar symmetraCloneDuration = createWorkshopSetting(int[0:20], "Symmetra", "Light Clone duration", 12, 0)


rule "[symmetra.del] Light Clone Ult":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getUltCharge() == 100
    
    eventPlayer.setUltCharge(0)
    eventPlayer.setUltEnabled(false)
    #Create bot
    createDummy(Hero.SYMMETRA, eventPlayer.getTeam(), eventPlayer.getSlot() + 5, eventPlayer.getPosition(), eventPlayer.getFacingDirection())
    eventPlayer.SymmetraBotPlayer = getLastCreatedEntity()
    eventPlayer.SymmetraBotPlayer.setInvisibility(Invis.ALL)
    #Wait for bot to spawn
    waitUntil(eventPlayer.SymmetraBotPlayer.isAlive(), 1)
    waitUntil(eventPlayer.SymmetraBotPlayer.hasSpawned(), 1)
    #If the bot doesn't spawn, return ult back to Symmetra and abort
    if not entityExists(eventPlayer.SymmetraBotPlayer):
        eventPlayer.setUltCharge(100)
        eventPlayer.setUltEnabled(true)
        return
    wait()
    eventPlayer.SymmetraBotPlayer.startForcingName("{0}'s Light Clone".format(eventPlayer))
    eventPlayer.SymmetraBotPlayer.setAmmo(0, eventPlayer.getAmmo(0))
    eventPlayer.SymmetraBotPlayer.setDamageDealt(symmetraCloneDamageDealt)
    eventPlayer.SymmetraBotPlayer.setUltEnabled(false)
    eventPlayer.SymmetraBotPlayer.teleport(eventPlayer.getPosition())
    wait(0.08)
    #Create effects
    createEffect(getAllPlayers(), Effect.ECHO_CLONING, eventPlayer.getTeam(), eventPlayer.SymmetraBotPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    createEffect(getAllPlayers(), Effect.WINSTON_TESLA_CANNON_TARGET_SOUND, eventPlayer.getTeam(), eventPlayer.SymmetraBotPlayer, 700, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    for eventPlayer.Index in range(3):
        createEffect(getAllPlayers(), Effect.BAD_AURA, eventPlayer.getTeam(), eventPlayer.SymmetraBotPlayer, 0, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.HeroEffects.append(getLastCreatedEntity())
    #Casting
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.getTeam(), eventPlayer.SymmetraBotPlayer.getPosition(), 10)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATOR_DISAPPEAR_SOUND, eventPlayer.getTeam(), eventPlayer.SymmetraBotPlayer.getEyePosition(), 500)
    playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, eventPlayer.getTeam(), eventPlayer.SymmetraBotPlayer.getEyePosition(), 500)
    eventPlayer.SymmetraBotPlayer.setInvisibility(Invis.NONE)
    eventPlayer.communicate(Comms.ATTACKING)
    #Wait until the bot is dead or after 12 seconds have elapsed
    waitUntil(eventPlayer.SymmetraBotPlayer.isDead() or eventPlayer.isDead(), symmetraCloneDuration)
    wait()
    #Cleanup
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, eventPlayer.getTeam(), eventPlayer.SymmetraBotPlayer.getPosition(), 10)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATOR_DISAPPEAR_SOUND, eventPlayer.getTeam(), eventPlayer.SymmetraBotPlayer.getEyePosition(), 500)
    playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, eventPlayer.getTeam(), eventPlayer.SymmetraBotPlayer.getEyePosition(), 500)
    destroyDummy(eventPlayer.SymmetraBotPlayer.getTeam(), eventPlayer.SymmetraBotPlayer.getSlot())
    eventPlayer.setUltEnabled(true)
    eventPlayer.SymmetraBotPlayer = []
    CleanupEffects()


rule "[symmetra.del] Light Clone AI":
    @Event eachPlayer
    @Hero symmetra
    @Condition entityExists(eventPlayer.SymmetraBotPlayer) == true
    
    #Mirror the player's movement
    eventPlayer.SymmetraBotPlayer.startThrottleInDirection(directionTowards(worldVector(vect(0, 0, 0), eventPlayer, Transform.ROTATION_AND_TRANSLATION), worldVector(vect(-1 * eventPlayer.getThrottle().x, 0, eventPlayer.getThrottle().z), eventPlayer, Transform.ROTATION_AND_TRANSLATION)), eventPlayer.getHorizontalSpeed(), Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)
    eventPlayer.SymmetraBotPlayer.startFacing(updateEveryTick(directionTowards(eventPlayer.SymmetraBotPlayer.getEyePosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 500, getPlayers(getOppositeTeam(eventPlayer.getTeam())), [eventPlayer.SymmetraBotPlayer, eventPlayer], false).getHitPosition())), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    eventPlayer.SymmetraBotPlayer.disablePlayerCollision()
    eventPlayer.SymmetraBotPlayer.teleport(eventPlayer.getPosition())
    eventPlayer.SymmetraBotPlayer.startModifyingVoicelinePitch(random.uniform(0, 2), false)
    while entityExists(eventPlayer.SymmetraBotPlayer):
        #Mirror the player's actionsBUG: Symmetra Light Clone causes other players to hold their buttons for some reason?
        if eventPlayer.isFiringPrimaryFire():
            if not eventPlayer.SymmetraBotPlayer.isFiringPrimaryFire():
                eventPlayer.SymmetraBotPlayer.startForcingButton(Button.PRIMARY_FIRE)
        else:
            eventPlayer.SymmetraBotPlayer.stopForcingButton(Button.PRIMARY_FIRE)
        wait()
        if eventPlayer.isFiringSecondaryFire():
            if not eventPlayer.SymmetraBotPlayer.isFiringSecondaryFire():
                eventPlayer.SymmetraBotPlayer.startForcingButton(Button.SECONDARY_FIRE)
        else:
            eventPlayer.SymmetraBotPlayer.stopForcingButton(Button.SECONDARY_FIRE)
        wait()
        if eventPlayer.isReloading():
            if not eventPlayer.SymmetraBotPlayer.isReloading():
                eventPlayer.SymmetraBotPlayer.startForcingButton(Button.RELOAD)
        else:
            eventPlayer.SymmetraBotPlayer.stopForcingButton(Button.RELOAD)
        wait()
        if eventPlayer.isJumping():
            if not eventPlayer.SymmetraBotPlayer.isJumping():
                eventPlayer.SymmetraBotPlayer.startForcingButton(Button.JUMP)
        else:
            eventPlayer.SymmetraBotPlayer.stopForcingButton(Button.JUMP)
        wait()
        if eventPlayer.isCrouching():
            if not eventPlayer.SymmetraBotPlayer.isCrouching():
                eventPlayer.SymmetraBotPlayer.startForcingButton(Button.CROUCH)
        else:
            eventPlayer.SymmetraBotPlayer.stopForcingButton(Button.CROUCH)
        wait()


