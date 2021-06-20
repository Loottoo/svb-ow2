#!mainFile "../../main.opy"

playervar LungeCharges
playervar HanzoVars
playervar HanzoReload


rule "Global Hanzo Damage Mod":
    startDamageModification(getAllPlayers(), [player for player in getAllPlayers() if player.getCurrentHero() == Hero.HANZO], 60, DamageReeval.RECEIVERS_AND_DAMAGERS)


rule "Hanzo Global Effects and Hud":
    createInWorldText([i for i in localPlayer if not localPlayer.isDead() and localPlayer.getCurrentHero() == Hero.HANZO], "{0}".format(floor(localPlayer.LungeCharges)), updateEveryTick(localPlayer.getEyePosition() + localPlayer.getFacingDirection() * 50 + normalize(crossProduct(crossProduct(Vector.UP, localPlayer.getFacingDirection()), localPlayer.getFacingDirection())) * 26.5 + normalize(crossProduct(Vector.UP, localPlayer.getFacingDirection())) * -39.25), 2.4, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    createInWorldText([i for i in localPlayer if not localPlayer.isDead() and localPlayer.getCurrentHero() == Hero.HANZO], "{0}/12".format(floor(localPlayer.HanzoVars[0])), updateEveryTick(localPlayer.getEyePosition() + localPlayer.getFacingDirection() * 50 + normalize(crossProduct(crossProduct(Vector.UP, localPlayer.getFacingDirection()), localPlayer.getFacingDirection())) * 26.5 + normalize(crossProduct(Vector.UP, localPlayer.getFacingDirection())) * -50), 2.4, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    createProgressBarInWorldText([i for i in localPlayer if not localPlayer.isDead() and localPlayer.getCurrentHero() == Hero.HANZO], 100 if localPlayer.LungeCharges == 2 else localPlayer.LungeCharges % 1 * 100, "Lunges: {0}".format(floor(localPlayer.LungeCharges)), updateEveryTick(localPlayer.getEyePosition() + localPlayer.getFacingDirection() * 30 + normalize(crossProduct(crossProduct(Vector.UP, localPlayer.getFacingDirection()), localPlayer.getFacingDirection())) * 5.25 + normalize(crossProduct(Vector.UP, localPlayer.getFacingDirection())) * 0), 0.575, Clip.NONE, rgba(255, 255, 255, 100) if localPlayer.LungeCharges < 1 else rgba(150, 150, 255, 180), Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_VALUES_AND_COLOR, SpecVisibility.DEFAULT)
    createEffect([i for i in localPlayer if ((((localPlayer.getCurrentHero() == Hero.HANZO and (not localPlayer.HanzoVars[0] or localPlayer.HanzoReload)) and not localPlayer.isMeleeing()) and not localPlayer.isUsingUltimate()) and not localPlayer.isFiringPrimaryFire()) and not localPlayer.isUsingAbility2()], Effect.GOOD_AURA, Color.SKY_BLUE, updateEveryTick(localPlayer.getEyePosition() + (localPlayer.getFacingDirection() * (0.2 + 0.035 * (sinDeg(localPlayer.HanzoReload * 360 * 3.5)))) + (normalize(crossProduct(localPlayer.getFacingDirection(), Vector.UP)) * (-0.225 + 0.45 * localPlayer.HanzoReload)) + (normalize(crossProduct(crossProduct(localPlayer.getFacingDirection(), Vector.UP), localPlayer.getFacingDirection())) * (-0.135 + 0.035 * localPlayer.HanzoReload + 0.035 * (cosDeg(localPlayer.HanzoReload * 360 * 3.5))))), 0.045, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


def InitialHanzo():
    @Name "[Sub] Initial Hanzo"
    
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.LungeCharges = 2
    chase(eventPlayer.LungeCharges, 2, rate=0.2, ChaseReeval.NONE)
    #HanzoVars will be Ammo at index 0, and a Boolean for if Secondary is being fired at index 1, and a boolean for if the arrow has been cancelled at index 2
    eventPlayer.HanzoVars = []
    eventPlayer.HanzoVars[0] = 12
    eventPlayer.setProjectileSpeed(12500 / 110)


def CleanupHanzo():
    @Name "[Sub] Cleanup Hanzo"
    
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    stopChasingVariable(eventPlayer.LungeCharges)
    stopChasingVariable(eventPlayer.HanzoReload)
    eventPlayer.HanzoReload = 0
    eventPlayer.setProjectileSpeed(100)


rule "Hanzo Reduce Ammo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    eventPlayer.HanzoVars[0] -= 1
    eventPlayer.HanzoVars[2] = false
    waitUntil(not eventPlayer.isFiringPrimaryFire(), 99999)
    if eventPlayer.isUsingUltimate() or eventPlayer.isMeleeing() or eventPlayer.isOnWall():
        if eventPlayer.HanzoVars[2]:
            goto lbl_0
        eventPlayer.HanzoVars[0] += 1
        eventPlayer.HanzoVars[2] = true
        lbl_0:
    if RULE_CONDITION:
        goto RULE_START


rule "Hanzo Reload":
    @Event eachPlayer
    @Hero hanzo
    @Condition (eventPlayer.HanzoVars[0] < 1 or eventPlayer.isHoldingButton(Button.RELOAD)) == true
    @Condition eventPlayer.HanzoVars[0] != 12
    @Condition eventPlayer.isMeleeing() == false
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.isUsingAbility2() == false
    
    if eventPlayer.HanzoVars[0] == 0:
        waitUntil(not eventPlayer.isFiringPrimaryFire(), 99999)
        waitUntil(eventPlayer.isMeleeing() or eventPlayer.isUsingUltimate(), 0.032)
        if eventPlayer.isMeleeing() or eventPlayer.isUsingUltimate() or eventPlayer.HanzoVars[0] > 0:
            stopChasingVariable(eventPlayer.HanzoReload)
            eventPlayer.HanzoReload = 0
            if eventPlayer.HanzoVars[0] < 1:
                goto lbl_0
            eventPlayer.allowButton(Button.PRIMARY_FIRE)
            lbl_0:
            return
    else:
        waitUntil(not eventPlayer.isFiringPrimaryFire(), 99999)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    stopChasingVariable(eventPlayer.HanzoReload)
    eventPlayer.HanzoReload = 0
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 15)
    waitUntil(eventPlayer.isMeleeing() or eventPlayer.isUsingUltimate(), 0.232)
    if eventPlayer.isMeleeing() or eventPlayer.isUsingUltimate():
        stopChasingVariable(eventPlayer.HanzoReload)
        eventPlayer.HanzoReload = 0
        if eventPlayer.HanzoVars[0] < 1:
            goto lbl_1
        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        lbl_1:
        return
    chase(eventPlayer.HanzoReload, 1, rate=1 / 1.5, ChaseReeval.NONE)
    waitUntil(eventPlayer.isMeleeing() or eventPlayer.isUsingUltimate(), 1)
    if eventPlayer.isMeleeing() or eventPlayer.isUsingUltimate():
        stopChasingVariable(eventPlayer.HanzoReload)
        eventPlayer.HanzoReload = 0
        if eventPlayer.HanzoVars[0] < 1:
            goto lbl_2
        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        lbl_2:
        return
    eventPlayer.HanzoVars[0] = 12
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 20)
    wait(0.5)
    stopChasingVariable(eventPlayer.HanzoReload)
    eventPlayer.HanzoReload = 0
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 65)


rule "Hanzo Respawn With Full Ammo":
    @Event playerDied
    @Hero hanzo
    
    eventPlayer.HanzoVars[0] = 12


rule "Main Secondary Fire":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.HanzoReload == 0
    #@Condition eventPlayer.HanzoVars[0] > 0
    
    wait()
    if eventPlayer.isFiringPrimaryFire():
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
        eventPlayer.disallowButton(Button.SECONDARY_FIRE)
        if eventPlayer.HanzoVars[2]:
            goto lbl_0
        eventPlayer.HanzoVars[0] += 1
        eventPlayer.HanzoVars[2] = true
        lbl_0:
        return
    if eventPlayer.HanzoVars[0] < 1:
        return
    eventPlayer.HanzoVars[1] = true
    eventPlayer.setDamageDealt(3500 / 70)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    while eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.HanzoVars[0] > 0:
        if not eventPlayer.isUsingAbility2():
            eventPlayer.setAbility2Enabled(true)
            eventPlayer.forceButtonPress(Button.ABILITY_2)
            eventPlayer.setAbility2Enabled(false)
            wait(0.048)
        else:
            if not (eventPlayer.isMeleeing() or eventPlayer.isUsingUltimate()):
                eventPlayer.allowButton(Button.PRIMARY_FIRE)
                eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
                eventPlayer.disallowButton(Button.PRIMARY_FIRE)
                eventPlayer.HanzoVars[0] -= 1
                eventPlayer.HanzoVars[2] = false
        wait(0.248)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.setAbility2Enabled(false)
    if eventPlayer.isUsingAbility2():
        eventPlayer.forceButtonPress(Button.ABILITY_2)
    if eventPlayer.isUsingAbility2():
        eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(0.25)
    eventPlayer.HanzoVars[1] = false
    eventPlayer.setDamageDealt(100)
    if eventPlayer.HanzoVars[0] < 1:
        goto lbl_1
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    lbl_1:
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    if RULE_CONDITION:
        goto RULE_START


rule "Secondary Cancel":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "Hanzo's damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility != null
    
    if eventAbility == Button.MELEE:
        damage(victim, eventPlayer, ((30 - eventDamage) / 0.6) * (2 if eventPlayer.HanzoVars[1] else 1))
    elif eventAbility == Button.ULTIMATE:
        damage(victim, eventPlayer, (eventDamage) * 2 * (2 / 3 / 0.6) * (2 if eventPlayer.HanzoVars[1] else 1))
    else:
        damage(victim, eventPlayer, (eventDamage * (2 / 3 / 0.6) * (max(1 - ((max(distance(victim, eventPlayer) - 15, 0)) / 30), 0))) * (2 if eventPlayer.HanzoVars[1] else 1))


rule "Lunge Charges":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.getAbilityCooldown(Button.JUMP) == true
    
    eventPlayer.LungeCharges -= 1
    eventPlayer.setAbilityCooldown(Button.JUMP, 5 - eventPlayer.LungeCharges * 5)
