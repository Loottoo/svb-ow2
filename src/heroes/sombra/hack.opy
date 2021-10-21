#!mainFile "../../main.opy"


globalvar sombraHackDuration = createWorkshopSetting(float[0:10], "Sombra", "Hack Duration", 5, 0)
globalvar sombraHackCooldown = createWorkshopSetting(float[0:30], "Sombra", "Hack Cooldown", 8, 1)


rule "Hack Melee, but not if healthpack is only valid target":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition not specialAbilitiesDisabled(eventPlayer)

    if eventPlayer.isMeleeing():
        return
    if eventPlayer.isUsingAbility1():
        wait(0.464)
    if specialAbilitiesDisabled(eventPlayer):
        return
    if ([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.isAlive() and not player.hasStatusEffect(Status.INVINCIBLE) and not player.hasStatusEffect(Status.PHASED_OUT) and player in getPlayersInRadius(eventPlayer.getEyePosition(), 18, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) and player in eventPlayer.getPlayersInViewAngle(getOppositeTeam(eventPlayer.getTeam()), 50)]) == []:
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
        waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != 0 or ([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.isAlive() and not player.hasStatusEffect(Status.INVINCIBLE) and not player.hasStatusEffect(Status.PHASED_OUT) and player in getPlayersInRadius(eventPlayer.getEyePosition(), 18, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) and player in eventPlayer.getPlayersInViewAngle(getOppositeTeam(eventPlayer.getTeam()), 50)]) != [], 99999)
        eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
        eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    else:
        eventPlayer.HackMelee = 0.001
        chase(eventPlayer.HackMelee, 1, rate=1.667, ChaseReeval.NONE)
        eventPlayer.setAbilityCooldown(Button.MELEE, 0)
        eventPlayer.forceButtonPress(Button.MELEE)
        wait()
        waitUntil(eventPlayer.HackMelee == 1, 0.6)
        stopChasingVariable(eventPlayer.HackMelee)
        eventPlayer.HackMelee = 0
    eventPlayer.HackHit = false


rule "Sombra damage checks (hack melee and increase primary)":
    @Event playerDealtDamage
    @Hero sombra

    if eventAbility == Button.MELEE and eventPlayer.HackMelee != 0:
        if eventPlayer.HackHit:
            goto lbl_0
        victim.setStatusEffect(eventPlayer, Status.HACKED, sombraHackDuration)
        playEffect(getAllPlayers(), DynamicEffect.SOMBRA_LOGO_SOUND, eventPlayer.getTeam(), victim.getPosition(), 160)
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, sombraHackCooldown)
        eventPlayer.HackHit = true
    if eventAbility == Button.PRIMARY_FIRE:
        lbl_0:
        damage(victim, eventPlayer, (4 if victim.getHealthOfType(Health.ARMOR) else 2) if eventWasCriticalHit else 1)

