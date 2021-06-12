#!mainFile "../../main.opy"


subroutine ZapHitDetection


def ZapHitDetection():
    @Name "Zap Hitdetection"

    for ZapLoop in range(len(ZapHitboxArray)):
        eventPlayer.ZapHitPlayer = raycast(
            vect(0, eventPlayer.getEyePosition().y - eventPlayer.getPosition().y, 0) + worldVector(ZapHitboxArray[ZapLoop], eventPlayer, Transform.ROTATION_AND_TRANSLATION),
            vect(0, eventPlayer.getEyePosition().y - eventPlayer.getPosition().y, 0) + worldVector(ZapHitboxArray[ZapLoop], eventPlayer, Transform.ROTATION_AND_TRANSLATION) + eventPlayer.getFacingDirection() * ZapRange,
            [player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.isAlive()],
            eventPlayer,
            true
        ).getPlayerHit()

        #createBeam(getAllPlayers(), Beam.GRAPPLE,
        #   vect(0, eventPlayer.getEyePosition().y - eventPlayer.getPosition().y, 0) + worldVector(ZapHitboxArray[ZapLoop], eventPlayer, Transform.ROTATION_AND_TRANSLATION),
        #   raycast(
        #       vect(0, eventPlayer.getEyePosition().y - eventPlayer.getPosition().y, 0) + worldVector(ZapHitboxArray[ZapLoop], eventPlayer, Transform.ROTATION_AND_TRANSLATION),
        #       vect(0, eventPlayer.getEyePosition().y - eventPlayer.getPosition().y, 0) + worldVector(ZapHitboxArray[ZapLoop], eventPlayer, Transform.ROTATION_AND_TRANSLATION) + eventPlayer.getFacingDirection() * ZapRange,
        #       getPlayers(getOppositeTeam(eventPlayer.getTeam())),
        #       eventPlayer,
        #       true
        #   ).getHitPosition(),
        #   Color.WHITE,
        #   EffectReeval.NONE
        #)

        if eventPlayer.ZapHitPlayer:
            damage(eventPlayer.ZapHitPlayer, eventPlayer, ZapDamage)
            break


rule "Create Zap Radius Array":
    ZapHitboxArray = [
        vect(0, 0, 0) + Vector.FORWARD * ZapRadius,
        Vector.LEFT * ZapRadius,
        Vector.RIGHT * ZapRadius,
        Vector.UP * ZapRadius,
        Vector.DOWN * ZapRadius,
        Vector.LEFT * ZapRadius * 0.702 + Vector.UP * ZapRadius * 0.702,
        Vector.LEFT * ZapRadius * 0.702 + Vector.DOWN * ZapRadius * 0.702,
        Vector.RIGHT * ZapRadius * 0.702 + Vector.UP * ZapRadius * 0.702,
        Vector.RIGHT * ZapRadius * 0.702 + Vector.DOWN * ZapRadius * 0.702
    ]


rule "Fire Zap":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.isReloading() == false
    
    CheckStatus()
    if eventPlayer.p_ZapCharges == 0:
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)
    else:
        eventPlayer.ZapEffects = []
        createEffect(eventPlayer, Effect.GOOD_AURA, Color.SKY_BLUE if eventPlayer.ZapChargeMeter < 100 else Color.BLUE, updateEveryTick(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 0.675 + normalize(crossProduct(crossProduct(Vector.UP, eventPlayer.getFacingDirection()), eventPlayer.getFacingDirection())) * 0.262 + normalize(crossProduct(Vector.UP, eventPlayer.getFacingDirection())) * -0.135), 0.03 * eventPlayer.ZapChargeMeter / 100, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        eventPlayer.ZapEffects.append(getLastCreatedEntity())
        createEffect(getAllPlayers(), Effect.ENERGY_SOUND, Color.WHITE, eventPlayer, eventPlayer.ZapChargeMeter * 2, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        eventPlayer.ZapEffects.append(getLastCreatedEntity())
        eventPlayer.ZapChargeMeter = 0
        hudSubheader(eventPlayer, " \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n", HudPosition.TOP, 20, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        eventPlayer.ZapHUDSpacer = getLastCreatedText()
        eventPlayer.DeletableHUD = eventPlayer.DeletableHUD.concat(getLastCreatedText())
        progressBarHud(eventPlayer, eventPlayer.ZapChargeMeter, " " if eventPlayer.ZapChargeMeter < 100 else "READY", HudPosition.TOP, 21, Color.WHITE if eventPlayer.ZapChargeMeter < 100 else Color.BLUE, Color.WHITE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)
        eventPlayer.ZapHudProgress = getLastCreatedText()
        chase(eventPlayer.ZapChargeMeter, 100, duration=ZapChargeTime, ChaseReeval.DESTINATION_AND_DURATION)
        waitUntil(eventPlayer.ZapChargeMeter >= 100 or not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 99999)
        if eventPlayer.ZapChargeMeter >= 100:
            waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), createWorkshopSetting(float[0:5], "Winston", "Zap Max Hold Time", 1, 0))
            destroyEffect(eventPlayer.ZapEffects)
            destroyHudText(eventPlayer.ZapHUDSpacer)
            destroyProgressBarHud(eventPlayer.ZapHudProgress)
            eventPlayer.p_ZapCharges -= 1
            ZapHitDetection()
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.BLUE, eventPlayer, 100)

            createBeam(
                getAllPlayers(),
                Beam.BAD,
                worldVector(Vector.UP * 0.75 + Vector.RIGHT * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION),
                raycast(
                    eventPlayer.getEyePosition(),
                    eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * (distance(eventPlayer, eventPlayer.ZapHitPlayer) + 1 if eventPlayer.ZapHitPlayer else ZapRange),
                    [player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.isAlive()],
                    eventPlayer,
                    true
                ).getHitPosition(),
                Color.AQUA,
                EffectReeval.VISIBILITY_AND_COLOR
            )
            eventPlayer.ZapEffects.append(getLastCreatedEntity())

            createBeam(
                getAllPlayers(),
                Beam.GOOD,
                worldVector(Vector.UP * 0.75 + Vector.RIGHT * 0.5, eventPlayer, Transform.ROTATION_AND_TRANSLATION),
                raycast(
                    eventPlayer.getEyePosition(),
                    eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * (distance(eventPlayer, eventPlayer.ZapHitPlayer) + 1 if eventPlayer.ZapHitPlayer else ZapRange),
                    [player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.isAlive()],
                    eventPlayer,
                    true
                ).getHitPosition(),
                Color.BLUE,
                EffectReeval.VISIBILITY_AND_COLOR
            )
            eventPlayer.ZapEffects.append(getLastCreatedEntity())

            if eventPlayer.ZapHitPlayer:
                playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.AQUA, eventPlayer.ZapHitPlayer, 1)
                playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.BLUE, eventPlayer.ZapHitPlayer, 2)
            eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) - 25)
            wait(1)
            eventPlayer.ZapHitPlayer = null
            for eventPlayer.INDEX in range(len(eventPlayer.ZapEffects)):
                destroyEffect(eventPlayer.ZapEffects[eventPlayer.INDEX])
                destroyHudText(eventPlayer.ZapEffects[eventPlayer.INDEX])
                destroyProgressBarHud(eventPlayer.ZapEffects[eventPlayer.INDEX])
                wait()
        else:
            stopChasingVariable(eventPlayer.ZapChargeMeter)
            eventPlayer.ZapChargeMeter = 0
            destroyEffect(eventPlayer.ZapEffects)
            destroyHudText(eventPlayer.ZapHUDSpacer)
            destroyProgressBarHud(eventPlayer.ZapHudProgress)


rule "Zap regen":
    @Event eachPlayer
    @Condition eventPlayer.p_ZapCharges < ZapCharges
    
    eventPlayer.ZapChargeMeter = 0
    chase(eventPlayer.ZapChargeMeter, ZapCooldown, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    waitUntil(eventPlayer.ZapChargeMeter >= ZapCooldown, 99999)
    eventPlayer.p_ZapCharges += 1
    if RULE_CONDITION:
        goto RULE_START


