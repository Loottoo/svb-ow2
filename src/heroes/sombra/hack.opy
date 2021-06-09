#!mainFile "../../main.opy"


globalvar sombraHackDuration = createWorkshopSetting(float[0:10], "Sombra", "Hack Duration", 2, 0)
globalvar sombraHackCooldown = createWorkshopSetting(float[0:30], "Sombra", "Hack Cooldown", 10, 1)


def SombraProjectileHit():
    @Name "[sombra.del] Subroutine: Projectile Hit"
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, sombraHackCooldown)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    stopChasingVariable(eventPlayer.SombraProjectilePosition)
    #If the projectile isn't blocked by a barrier or the target is not phased out, we can apply the hack status
    if not eventPlayer.SombraSelectedTarget.hasStatusEffect(Status.PHASED_OUT) and not eventPlayer.SombraSelectedTarget.hasStatusEffect(Status.INVINCIBLE) and (not (isInLoS(eventPlayer.SombraProjectilePosition, eventPlayer.SombraProjectilePosition + directionTowards(eventPlayer.SombraProjectilePosition, eventPlayer.SombraSelectedTarget.getEyePosition()), BarrierLos.PASS_THROUGH_BARRIERS) and not isInLoS(eventPlayer.SombraProjectilePosition, eventPlayer.SombraProjectilePosition + directionTowards(eventPlayer.SombraProjectilePosition, eventPlayer.SombraSelectedTarget.getEyePosition()), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS))):
        eventPlayer.SombraSelectedTarget.setStatusEffect(eventPlayer, Status.HACKED, sombraHackDuration)
    #Team Effects
    playEffect(getPlayers(eventPlayer.getTeam()), DynamicEffect.BAD_EXPLOSION, Color.PURPLE, eventPlayer.SombraProjectilePosition, 1)
    #Enemy Effects
    playEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())), DynamicEffect.BAD_EXPLOSION, Color.RED, eventPlayer.SombraProjectilePosition, 1)
    #Effects
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer.SombraProjectilePosition, 100)
    eventPlayer.SombraProjectilePosition = null
    eventPlayer.SombraSelectedTarget = null


rule "[sombra.del] Projectile Hit":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.SombraProjectilePosition != null
    @Condition (distance(eventPlayer.SombraSelectedTarget.getEyePosition(), eventPlayer.SombraProjectilePosition) < 1 or isInLoS(eventPlayer.SombraProjectilePosition, eventPlayer.SombraProjectilePosition + directionTowards(eventPlayer.SombraProjectilePosition, eventPlayer.SombraSelectedTarget.getEyePosition()), BarrierLos.PASS_THROUGH_BARRIERS) and not isInLoS(eventPlayer.SombraProjectilePosition, eventPlayer.SombraProjectilePosition + directionTowards(eventPlayer.SombraProjectilePosition, eventPlayer.SombraSelectedTarget.getEyePosition()), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer.SombraProjectilePosition, eventPlayer.SombraSelectedTarget.getEyePosition()) < 5) == true
    
    SombraProjectileHit()


def SombraLaunchProjectile():
    @Name "[sombra.del] Subroutine: Launch Projectile"
    
    eventPlayer.SombraSelectedTarget = (sorted([i for i in getPlayersInRadius(eventPlayer.getEyePosition(), 30, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF).exclude(eventPlayer).exclude(getDeadPlayers(Team.ALL)) if eventPlayer.isInViewAngle(i, 30) and (not (eventPlayer.getCurrentHero() == Hero.SOMBRA and eventPlayer.isUsingAbility1())) and (not ((i.getCurrentHero() in ForbiddenUltimateHeroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingUltimate() or ((i.getCurrentHero() in ForbiddenAbility1Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility1()) or ((i.getCurrentHero() in ForbiddenAbility2Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility2())))], lambda i: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), i.getEyePosition())) + distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]
    #Check if we can target the enemy
    waitUntil(not eventPlayer.isFiringSecondaryFire() or distance(eventPlayer, eventPlayer.SombraSelectedTarget) <= 15.1 and isInLoS(eventPlayer, eventPlayer.SombraSelectedTarget, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS), 9999)
    if not eventPlayer.isFiringSecondaryFire() or distance(eventPlayer, eventPlayer.SombraSelectedTarget) > 15.1 or not entityExists(eventPlayer.SombraSelectedTarget) or not isInLoS(eventPlayer, eventPlayer.SombraSelectedTarget, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS):
        return
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.SombraProjectilePosition = eventPlayer.getEyePosition()
    chase(eventPlayer.SombraProjectilePosition, eventPlayer.SombraSelectedTarget.getEyePosition(), rate=50, ChaseReeval.DESTINATION_AND_RATE)


rule "[sombra.del] Launch Projectile":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition ((sorted([i for i in getPlayersInRadius(eventPlayer.getEyePosition(), 30, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF).exclude(eventPlayer).exclude(getDeadPlayers(Team.ALL)) if eventPlayer.isInViewAngle(i, 30) and (not (eventPlayer.getCurrentHero() == Hero.SOMBRA and eventPlayer.isUsingAbility1())) and (not ((i.getCurrentHero() in ForbiddenUltimateHeroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingUltimate() or ((i.getCurrentHero() in ForbiddenAbility1Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility1()) or ((i.getCurrentHero() in ForbiddenAbility2Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility2())))], lambda i: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), i.getEyePosition())) + distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]) == true
    
    SombraLaunchProjectile()


rule "[sombra.del] Projectile Hit (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.SOMBRA
    @Condition eventPlayer.SombraProjectilePosition != null
    @Condition (distance(eventPlayer.SombraSelectedTarget.getEyePosition(), eventPlayer.SombraProjectilePosition) < 1 or isInLoS(eventPlayer.SombraProjectilePosition, eventPlayer.SombraProjectilePosition + directionTowards(eventPlayer.SombraProjectilePosition, eventPlayer.SombraSelectedTarget.getEyePosition()), BarrierLos.PASS_THROUGH_BARRIERS) and not isInLoS(eventPlayer.SombraProjectilePosition, eventPlayer.SombraProjectilePosition + directionTowards(eventPlayer.SombraProjectilePosition, eventPlayer.SombraSelectedTarget.getEyePosition()), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer.SombraProjectilePosition, eventPlayer.SombraSelectedTarget.getEyePosition()) < 5) == true
    
    SombraProjectileHit()


rule "[sombra.del] Launch Projectile (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.SOMBRA
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition ((sorted([i for i in getPlayersInRadius(eventPlayer.getEyePosition(), 30, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF).exclude(eventPlayer).exclude(getDeadPlayers(Team.ALL)) if eventPlayer.isInViewAngle(i, 30) and (not (eventPlayer.getCurrentHero() == Hero.SOMBRA and eventPlayer.isUsingAbility1())) and (not ((i.getCurrentHero() in ForbiddenUltimateHeroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingUltimate() or ((i.getCurrentHero() in ForbiddenAbility1Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility1()) or ((i.getCurrentHero() in ForbiddenAbility2Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility2())))], lambda i: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), i.getEyePosition())) + distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]) == true
    
    SombraLaunchProjectile()
