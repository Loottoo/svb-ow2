#!mainFile "../../main.opy"


def CleanupSombra():
    @Name "[sombra.del] Subroutine: Cleanup"
    
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    CleanupEffects()
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.SombraProjectilePosition = null
    eventPlayer.SombraSelectedTarget = null
    stopChasingVariable(eventPlayer.SombraProjectilePosition)
    wait()
    eventPlayer.HeroActive = null


def InitialSombra():
    @Name "[sombra.del] Subroutine: Initial"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == Hero.SOMBRA:
        return
    wait()
    eventPlayer.HeroActive = Hero.SOMBRA
    #Team Effects
    createEffect(getPlayers(eventPlayer.getTeam()) if eventPlayer.SombraProjectilePosition != null else null, Effect.BAD_AURA, Color.PURPLE, updateEveryTick(eventPlayer.SombraProjectilePosition), 0, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    createEffect(getPlayers(eventPlayer.getTeam()) if eventPlayer.SombraProjectilePosition != null else null, Effect.ORB, Color.PURPLE, updateEveryTick(eventPlayer.SombraProjectilePosition), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    #Enemy Effects
    createEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())) if eventPlayer.SombraProjectilePosition != null else null, Effect.BAD_AURA, Color.RED, updateEveryTick(eventPlayer.SombraProjectilePosition), 0, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    createEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())) if eventPlayer.SombraProjectilePosition != null else null, Effect.ORB, Color.RED, updateEveryTick(eventPlayer.SombraProjectilePosition), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.HeroEffects.append(getLastCreatedEntity())
    async(CleanupSombra, AsyncBehavior.NOOP)


rule "[sombra.del] Initial":
    @Event eachPlayer
    @Hero sombra
    
    InitialSombra()


rule "[sombra.del] Initial (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.SOMBRA
    
    InitialSombra()
