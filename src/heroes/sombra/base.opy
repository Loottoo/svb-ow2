#!mainFile "../../main.opy"

playervar HackMelee
playervar HackHit

rule "Sombra hack melee effect":
    createEffect([i for i in localPlayer if localPlayer.HackMelee != 0], Effect.GOOD_AURA, Color.PURPLE, updateEveryTick(localPlayer.getEyePosition() + localPlayer.getFacingDirection() * 0.5 + ((normalize(crossProduct(localPlayer.getFacingDirection(), Vector.UP)) * (0.3 - (((0.25 * (max(localPlayer.HackMelee - 0.075, 0))) * 1) / 0.075)) + (normalize(crossProduct(crossProduct(localPlayer.getFacingDirection(), Vector.UP), localPlayer.getFacingDirection())) * (-0.25 + 0.35 * (min(localPlayer.HackMelee * 1 / 0.075, 1)))) if localPlayer.HackMelee < 0.15 else normalize(crossProduct(localPlayer.getFacingDirection(), Vector.UP)) * 0.05 + normalize(crossProduct(crossProduct(localPlayer.getFacingDirection(), Vector.UP), localPlayer.getFacingDirection())) * 0.1 if localPlayer.HackMelee < 0.6 else normalize(crossProduct(localPlayer.getFacingDirection(), Vector.UP)) * (0.05 + (0.25 * (min(((localPlayer.HackMelee - 0.6) * 1) / 0.25, 1)))) + (normalize(crossProduct(crossProduct(localPlayer.getFacingDirection(), Vector.UP), localPlayer.getFacingDirection())) * (0.1 - (0.35 * (((max(localPlayer.HackMelee - 0.85, 0)) * 1) / 0.15))))) * 1)), 0.17, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


def CleanupSombra():
    @Name "[sombra.del] Subroutine: Cleanup"
    
    stopChasingVariable(eventPlayer.HackMelee)
    eventPlayer.HackMelee = 0
    eventPlayer.allowButton(Button.SECONDARY_FIRE)


def InitialSombra():
    @Name "[sombra.del] Subroutine: Initial"

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
