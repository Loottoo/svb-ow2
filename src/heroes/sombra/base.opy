#!mainFile "../../main.opy"


def CleanupSombra():
    @Name "[sombra.del] Subroutine: Cleanup"
    
    CleanupEffects()
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.SombraProjectilePosition = null
    eventPlayer.SombraSelectedTarget = null
    stopChasingVariable(eventPlayer.SombraProjectilePosition)


def InitialSombra():
    @Name "[sombra.del] Subroutine: Initial"
    
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
