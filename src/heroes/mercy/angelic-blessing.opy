#!mainFile "../../main.opy"


def MercyAngelicBlessing():
    @Name "[mercy.del] Subroutine: Mercy Angelic Blessing"
    
    if eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0:
        return
    if eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.STUNNED) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.isDead():
        return
    #Get target
    eventPlayer.AngelicBlessingTarget = (sorted([i for i in getPlayersInRadius(eventPlayer.getEyePosition(), 30, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer).exclude(getDeadPlayers(Team.ALL)) if eventPlayer.isInViewAngle(i, 70) and (not (eventPlayer.getCurrentHero() == Hero.SOMBRA and eventPlayer.isUsingAbility1())) and (not ((i.getCurrentHero() in ForbiddenUltimateHeroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingUltimate() or ((i.getCurrentHero() in ForbiddenAbility1Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility1()) or ((i.getCurrentHero() in ForbiddenAbility2Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility2())))], lambda i: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), i.getEyePosition())) + distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]
    #Abort if Target is not valid
    if eventPlayer.AngelicBlessingTarget == null:
        return
    #Casting
    eventPlayer.setDamageDealt(0)
    eventPlayer.forceButtonPress(Button.MELEE)
    eventPlayer.setAbilityCooldown(Button.MELEE, 0)
    eventPlayer.AngelicBlessingPosition = eventPlayer.getEyePosition()
    eventPlayer.setAbility2Enabled(false)
    #Team Effects
    createEffect(getPlayers(eventPlayer.getTeam()), Effect.ORB, Color.YELLOW, eventPlayer.AngelicBlessingPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    #Enemy Effects
    createEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())), Effect.ORB, Color.ORANGE, eventPlayer.AngelicBlessingPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    eventPlayer.communicate(Comms.GO)
    chase(eventPlayer.AngelicBlessingPosition, eventPlayer.AngelicBlessingTarget.getEyePosition(), rate=100, ChaseReeval.DESTINATION_AND_RATE)
    waitUntil(distance(eventPlayer.AngelicBlessingPosition, eventPlayer.AngelicBlessingTarget.getEyePosition()) < 1, 9999)
    eventPlayer.setDamageDealt(100)
    #Angelic Blessing Target
    createInWorldText(getAllPlayers(), "{0}{1}".format(abilityIconString(Hero.MERCY, Button.ABILITY_1), "\n\n".substring(0, 2 if (localPlayer.getCurrentHero() == Hero.MERCY or localPlayer.getHeroOfDuplication() == Hero.MERCY) and eventPlayer.AngelicBlessingTarget.getTeam() == localPlayer.getTeam() or eventPlayer.AngelicBlessingTarget.hasStatusEffect(Status.HACKED) else 0)), eventPlayer.AngelicBlessingTarget, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.AngelicBlessingTextID = getLastCreatedText()
    eventPlayer.HeroTexts.append(eventPlayer.AngelicBlessingTextID)
    createInWorldText(eventPlayer.AngelicBlessingTarget, "Guardian Angel [{0}] |                                | [{0}] Guardian Angel".format(buttonString(Button.INTERACT)), updateEveryTick(localPlayer.getEyePosition() + (100 * (0 * (crossProduct(localPlayer.getFacingDirection(), angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + ((0.15 - 0.2) * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 1.32, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.AngelicBlessingConfirmID = getLastCreatedText()
    eventPlayer.HeroTexts.append(eventPlayer.AngelicBlessingTextID)
    smallMessage(eventPlayer.AngelicBlessingTarget, "Angelic Blessing Received by {0}".format(eventPlayer))
    stopChasingVariable(eventPlayer.AngelicBlessingPosition)
    CleanupEffects()
    eventPlayer.AngelicBlessings.append(eventPlayer.AngelicBlessingTarget)
    #Team Effects
    createEffect(getPlayers(eventPlayer.getTeam()), Effect.SPARKLES, Color.YELLOW, eventPlayer.AngelicBlessingTarget, 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    playEffect(getPlayers(eventPlayer.getTeam()), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.AngelicBlessingPosition, 1)
    #Enemy Effects
    createEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())), Effect.SPARKLES, Color.ORANGE, eventPlayer.AngelicBlessingTarget, 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    playEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())), DynamicEffect.GOOD_EXPLOSION, Color.ORANGE, eventPlayer.AngelicBlessingPosition, 1)
    #Effects
    createEffect(eventPlayer.AngelicBlessingTarget, Effect.HEAL_TARGET, eventPlayer.AngelicBlessingTarget.getTeam(), eventPlayer.AngelicBlessingTarget, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.AngelicBlessingPosition, 100)
    #Stop casting
    eventPlayer.AngelicBlessingPosition = null
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 12)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.AngelicBlessingTarget.disallowButton(Button.INTERACT)
    #Wait until target chooses to fly to a target, after 6 seconds have elapsed, or if the target is using an ability that restricts their movement
    waitUntil((eventPlayer.AngelicBlessingTarget.isHoldingButton(Button.INTERACT) and ((sorted([i for i in getPlayersInRadius(eventPlayer.AngelicBlessingTarget.getEyePosition(), 30, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer.AngelicBlessingTarget).exclude(getDeadPlayers(Team.ALL)) if eventPlayer.AngelicBlessingTarget.isInViewAngle(i, 70) and (not (eventPlayer.AngelicBlessingTarget.getCurrentHero() == Hero.SOMBRA and eventPlayer.isUsingAbility1())) and (not ((i.getCurrentHero() in ForbiddenUltimateHeroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingUltimate() or ((i.getCurrentHero() in ForbiddenAbility1Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility1()) or ((i.getCurrentHero() in ForbiddenAbility2Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility2())))], lambda i: angleBetweenVectors(eventPlayer.AngelicBlessingTarget.getFacingDirection(), directionTowards(eventPlayer.AngelicBlessingTarget.getEyePosition(), i.getEyePosition())) + distance(eventPlayer.AngelicBlessingTarget.getEyePosition(), i.getEyePosition())))[0])) and (not ((eventPlayer.AngelicBlessingTarget.getCurrentHero() in ForbiddenUltimateHeroes or eventPlayer.AngelicBlessingTarget.getHeroOfDuplication() in ForbiddenUltimateHeroes) and eventPlayer.AngelicBlessingTarget.isUsingUltimate() or ((eventPlayer.AngelicBlessingTarget.getCurrentHero() in ForbiddenAbility1Heroes or eventPlayer.AngelicBlessingTarget.getHeroOfDuplication() in ForbiddenUltimateHeroes) and eventPlayer.AngelicBlessingTarget.isUsingAbility1()) or ((eventPlayer.AngelicBlessingTarget.getCurrentHero() in ForbiddenAbility2Heroes or eventPlayer.AngelicBlessingTarget.getHeroOfDuplication() in ForbiddenUltimateHeroes) and eventPlayer.AngelicBlessingTarget.isUsingAbility2()))) or eventPlayer.AngelicBlessingTarget.getHeroOfDuplication() != evalOnce(eventPlayer.AngelicBlessingTarget.getHeroOfDuplication()), 6)
    eventPlayer.Superjumping = true if eventPlayer.AngelicBlessingTarget.isCrouching() else false
    eventPlayer.AngelicBlessingFlyTarget = (sorted([i for i in getPlayersInRadius(eventPlayer.AngelicBlessingTarget.getEyePosition(), 30, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer.AngelicBlessingTarget).exclude(getDeadPlayers(Team.ALL)) if eventPlayer.AngelicBlessingTarget.isInViewAngle(i, 70) and (not (eventPlayer.AngelicBlessingTarget.getCurrentHero() == Hero.SOMBRA and eventPlayer.isUsingAbility1())) and (not ((i.getCurrentHero() in ForbiddenUltimateHeroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingUltimate() or ((i.getCurrentHero() in ForbiddenAbility1Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility1()) or ((i.getCurrentHero() in ForbiddenAbility2Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility2())))], lambda i: angleBetweenVectors(eventPlayer.AngelicBlessingTarget.getFacingDirection(), directionTowards(eventPlayer.AngelicBlessingTarget.getEyePosition(), i.getEyePosition())) + distance(eventPlayer.AngelicBlessingTarget.getEyePosition(), i.getEyePosition())))[0]
    #Cleanup
    destroyInWorldText(eventPlayer.AngelicBlessingConfirmID)
    destroyInWorldText(eventPlayer.AngelicBlessingTextID)
    getAllPlayers().stopForcingOutlineFor(eventPlayer.AngelicBlessingTarget)
    CleanupEffects()
    #Effects
    createEffect(getAllPlayers(), Effect.SOLDIER_SPRINTING, Color.WHITE, eventPlayer.AngelicBlessingTarget, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    #If there is a valid fly target and the player isn't using an ability that restricts their movement, we GA
    if eventPlayer.AngelicBlessingTarget.isHoldingButton(Button.INTERACT) and eventPlayer.AngelicBlessingFlyTarget and (not ((eventPlayer.AngelicBlessingTarget.getCurrentHero() in ForbiddenUltimateHeroes or eventPlayer.AngelicBlessingTarget.getHeroOfDuplication() in ForbiddenUltimateHeroes) and eventPlayer.AngelicBlessingTarget.isUsingUltimate() or ((eventPlayer.AngelicBlessingTarget.getCurrentHero() in ForbiddenAbility1Heroes or eventPlayer.AngelicBlessingTarget.getHeroOfDuplication() in ForbiddenUltimateHeroes) and eventPlayer.AngelicBlessingTarget.isUsingAbility1()) or ((eventPlayer.AngelicBlessingTarget.getCurrentHero() in ForbiddenAbility2Heroes or eventPlayer.AngelicBlessingTarget.getHeroOfDuplication() in ForbiddenUltimateHeroes) and eventPlayer.AngelicBlessingTarget.isUsingAbility2()))):
        playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.AngelicBlessingPosition, 100)
        eventPlayer.AngelicBlessingTarget.setGravity(0)
        eventPlayer.AngelicBlessingTarget.setJumpVerticalSpeed(0)
        eventPlayer.AngelicBlessingTarget.setStatusEffect(null, Status.ROOTED, 9999)
        eventPlayer.Direction = directionTowards(eventPlayer.AngelicBlessingTarget.getPosition(), eventPlayer.AngelicBlessingFlyTarget.getPosition())
        #Cancel any movement the player has
        eventPlayer.AngelicBlessingTarget.applyImpulse(eventPlayer.AngelicBlessingTarget.getVelocity(), eventPlayer.AngelicBlessingTarget.getHorizontalSpeed() * -1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        #If the player is not superjumping or on the ground, we lift them up slightly to simulate GA
        if eventPlayer.AngelicBlessingTarget.isInAir() or eventPlayer.Superjumping:
            goto lbl_0
        eventPlayer.AngelicBlessingTarget.applyImpulse(Vector.UP, 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        #If the player is superjumping or in the air, we push them down slightly to simulate GA
        lbl_0:
        if eventPlayer.AngelicBlessingTarget.isInAir() or not eventPlayer.Superjumping:
            goto lbl_1
        eventPlayer.AngelicBlessingTarget.applyImpulse(Vector.DOWN, 1, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        lbl_1:
        wait()
        while distance(eventPlayer.AngelicBlessingTarget.getPosition(), eventPlayer.AngelicBlessingFlyTarget.getPosition()) > 2 and (not ((eventPlayer.AngelicBlessingTarget.getCurrentHero() in ForbiddenUltimateHeroes or eventPlayer.AngelicBlessingTarget.getHeroOfDuplication() in ForbiddenUltimateHeroes) and eventPlayer.AngelicBlessingTarget.isUsingUltimate() or ((eventPlayer.AngelicBlessingTarget.getCurrentHero() in ForbiddenAbility1Heroes or eventPlayer.AngelicBlessingTarget.getHeroOfDuplication() in ForbiddenUltimateHeroes) and eventPlayer.AngelicBlessingTarget.isUsingAbility1()) or ((eventPlayer.AngelicBlessingTarget.getCurrentHero() in ForbiddenAbility2Heroes or eventPlayer.AngelicBlessingTarget.getHeroOfDuplication() in ForbiddenUltimateHeroes) and eventPlayer.AngelicBlessingTarget.isUsingAbility2()))):
            #Impulse loop while the player isn't close to the fly target, isn't using any ability that restricts their movement, or hasn't jumped.
            eventPlayer.AngelicBlessingTarget.applyImpulse(eventPlayer.Direction, 0 * (1 - min(1, distance(eventPlayer.AngelicBlessingTarget.getPosition(), eventPlayer.AngelicBlessingFlyTarget.getPosition()) / 10)) + 17 * (min(1, distance(eventPlayer.AngelicBlessingTarget.getPosition(), eventPlayer.AngelicBlessingFlyTarget.getPosition()) / 10)), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
            #This impulse allows us to slow down the player as they approach their target to simulate GA
            eventPlayer.AngelicBlessingTarget.applyImpulse(eventPlayer.Direction, -1 * (17 * (1 - min(1, distance(eventPlayer.AngelicBlessingTarget.getPosition(), eventPlayer.AngelicBlessingFlyTarget.getPosition()) / 10)) + 0 * (min(1, distance(eventPlayer.AngelicBlessingTarget.getPosition(), eventPlayer.AngelicBlessingFlyTarget.getPosition()) / 10))), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            #If the player is within range of superjumping and jumps, we launch them up
            if eventPlayer.AngelicBlessingTarget.isHoldingButton(Button.JUMP) and distance(eventPlayer.AngelicBlessingTarget.getPosition(), eventPlayer.AngelicBlessingFlyTarget.getPosition()) < 4 and eventPlayer.Superjumping:
                eventPlayer.AngelicBlessingTarget.applyImpulse(Vector.UP, 8.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            #If the player jumps at any point during the GA, retain momentum and send them forward
            if eventPlayer.AngelicBlessingTarget.isHoldingButton(Button.JUMP):
                eventPlayer.AngelicBlessingTarget.applyImpulse(eventPlayer.Direction + Vector.UP / 4, 24, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                break
            #If there is no line of sight or the player flies past the target, break the loop
            if getTotalTimeElapsed() % 1 <= 0.08:
                if not isInLoS(eventPlayer.AngelicBlessingTarget.getEyePosition(), eventPlayer.AngelicBlessingTarget.getEyePosition() + directionTowards(eventPlayer.AngelicBlessingTarget.getPosition(), evalOnce(eventPlayer.AngelicBlessingFlyTarget.getPosition())), BarrierLos.PASS_THROUGH_BARRIERS) or dotProduct(eventPlayer.Direction, directionTowards(eventPlayer.AngelicBlessingTarget.getPosition(), eventPlayer.AngelicBlessingFlyTarget.getPosition())) < 0:
                    break
            wait(0.08)
    #Cleanup
    eventPlayer.AngelicBlessingTarget.setGravity(100)
    eventPlayer.AngelicBlessingTarget.setJumpVerticalSpeed(100)
    eventPlayer.AngelicBlessingTarget.allowButton(Button.INTERACT)
    eventPlayer.AngelicBlessingTarget.clearStatusEffect(Status.ROOTED)
    eventPlayer.AngelicBlessingTarget = null
    eventPlayer.AngelicBlessingFlyTarget = null
    getAllPlayers().stopForcingOutlineFor(eventPlayer.AngelicBlessingTarget)
    eventPlayer.HeroTexts.remove(eventPlayer.AngelicBlessingTextID)
    CleanupEffects()


rule "[mercy.del] Angelic Blessing":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    MercyAngelicBlessing()


def MercyAngelicBlessingOutline():
    @Name "[mercy.del] Subroutine: Update Mercy Angelic Blessing Player Target Outline"
    
    wait(0.032, Wait.ABORT_WHEN_FALSE)
    (getAllPlayers().exclude((sorted([i for i in getPlayersInRadius(eventPlayer.AngelicBlessingTarget.getEyePosition(), 30, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer.AngelicBlessingTarget).exclude(getDeadPlayers(Team.ALL)) if eventPlayer.AngelicBlessingTarget.isInViewAngle(i, 70) and (not (eventPlayer.AngelicBlessingTarget.getCurrentHero() == Hero.SOMBRA and eventPlayer.isUsingAbility1())) and (not ((i.getCurrentHero() in ForbiddenUltimateHeroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingUltimate() or ((i.getCurrentHero() in ForbiddenAbility1Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility1()) or ((i.getCurrentHero() in ForbiddenAbility2Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility2())))], lambda i: angleBetweenVectors(eventPlayer.AngelicBlessingTarget.getFacingDirection(), directionTowards(eventPlayer.AngelicBlessingTarget.getEyePosition(), i.getEyePosition())) + distance(eventPlayer.AngelicBlessingTarget.getEyePosition(), i.getEyePosition())))[0])).stopForcingOutlineFor(eventPlayer.AngelicBlessingTarget)
    ((sorted([i for i in getPlayersInRadius(eventPlayer.AngelicBlessingTarget.getEyePosition(), 30, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer.AngelicBlessingTarget).exclude(getDeadPlayers(Team.ALL)) if eventPlayer.AngelicBlessingTarget.isInViewAngle(i, 70) and (not (eventPlayer.AngelicBlessingTarget.getCurrentHero() == Hero.SOMBRA and eventPlayer.isUsingAbility1())) and (not ((i.getCurrentHero() in ForbiddenUltimateHeroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingUltimate() or ((i.getCurrentHero() in ForbiddenAbility1Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility1()) or ((i.getCurrentHero() in ForbiddenAbility2Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility2())))], lambda i: angleBetweenVectors(eventPlayer.AngelicBlessingTarget.getFacingDirection(), directionTowards(eventPlayer.AngelicBlessingTarget.getEyePosition(), i.getEyePosition())) + distance(eventPlayer.AngelicBlessingTarget.getEyePosition(), i.getEyePosition())))[0]).startForcingOutlineFor(eventPlayer.AngelicBlessingTarget, true, Color.YELLOW, OutlineVisibility.ALWAYS)
    if RULE_CONDITION:
        goto RULE_START
    getAllPlayers().stopForcingOutlineFor(eventPlayer.AngelicBlessingTarget)


rule "[mercy.del] Update Angelic Blessing Player Target Outline":
    @Event eachPlayer
    @Hero mercy
    @Condition (eventPlayer.AngelicBlessingTarget and not eventPlayer.AngelicBlessingFlyTarget) == true
    
    MercyAngelicBlessingOutline()


rule "[mercy.del] Update Angelic Blessing Player Target Outline (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MERCY
    @Condition (eventPlayer.AngelicBlessingTarget and not eventPlayer.AngelicBlessingFlyTarget) == true
    
    MercyAngelicBlessingOutline()
