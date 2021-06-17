#!mainFile "../../main.opy"


def CleanupSymmetra():
    @Name "[symmetra.del] Subroutine: Cleanup"
    
    destroyDummy(eventPlayer.SymmetraBotPlayer.getTeam(), eventPlayer.SymmetraBotPlayer.getSlot())
    CleanupEffects()
    CleanupTexts()
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.setUltEnabled(true)


def InitialSymmetra():
    @Name "[symmetra.del] Subroutine: Initial"
    
    eventPlayer.disallowButton(Button.ULTIMATE)
    #Create Hud
    hudSubtext(eventPlayer, "{0}({1})".format(" \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n                                                                                                                                                                                                 ", "Light Clone"), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    eventPlayer.HeroTexts.append(getLastCreatedText())
