#!mainFile "../../main.opy"


def CleanupSymmetra():
    @Name "[symmetra.del] Subroutine: Cleanup"
    
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    destroyDummy(eventPlayer.SymmetraBotPlayer.getTeam(), eventPlayer.SymmetraBotPlayer.getSlot())
    CleanupEffects()
    CleanupTexts()
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.setUltEnabled(true)
    wait()
    eventPlayer.HeroActive = null


def InitialSymmetra():
    @Name "[symmetra.del] Subroutine: Initial"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == Hero.SYMMETRA:
        return
    wait()
    eventPlayer.HeroActive = Hero.SYMMETRA
    eventPlayer.disallowButton(Button.ULTIMATE)
    #Create Hud
    hudSubtext(eventPlayer, "{0}({1})".format(" \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n                                                                                                                                                                                                 ", "Light Clone"), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    eventPlayer.HeroTexts.append(getLastCreatedText())
    async(CleanupSymmetra, AsyncBehavior.NOOP)


rule "[symmetra.del] Initial":
    @Event eachPlayer
    @Hero symmetra
    
    InitialSymmetra()


rule "[symmetra.del] Initial (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.SYMMETRA
    
    InitialSymmetra()
