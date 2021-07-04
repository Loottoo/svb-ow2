#!mainFile "../../main.opy"


def CleanupOrisa():
    @Name "[orisa.del] Subroutine: Cleanup"
    
    CleanupTexts()
    CleanupEffects()
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.stopForcingThrottle()
    eventPlayer.stopFacing()
    eventPlayer.stopCamera()
    eventPlayer.enablePlayerCollision()


def InitialOrisa():
    @Name "[orisa.del] Subroutine: Initial"
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    #Create Hud
    hudSubtext(eventPlayer, "{0}({1})".format(" \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n                                                                                                                                                                                                                                                                                                                                      ", "Gallop"), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    eventPlayer.HeroTexts.append(getLastCreatedText())
    eventPlayer.setProjectileSpeed(125)

