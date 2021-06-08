#!mainFile "../../main.opy"


def CleanupMercy():
    @Name "[mercy.del] Subroutine: Cleanup"
    
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    CleanupTexts()
    CleanupHealingMods()
    CleanupEffects()
    getAllPlayers().stopForcingOutlineFor(eventPlayer.AngelicBlessingTarget)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.AngelicBlessingTarget.allowButton(Button.INTERACT)
    wait()
    eventPlayer.HeroActive = null


def InitialMercy():
    @Name "[mercy.del] Subroutine: Initial"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == Hero.MERCY:
        return
    wait()
    eventPlayer.HeroActive = Hero.MERCY
    eventPlayer.HealingPercents = []
    eventPlayer.DegenerationEnabled = []
    eventPlayer.slot_0 = 0
    while eventPlayer.slot_0 < 5:
        eventPlayer.HealingPercents[eventPlayer.slot_0] = 1
        eventPlayer.DegenerationEnabled[eventPlayer.slot_0] = false
        eventPlayer.slot_0 += 1
    eventPlayer.slot_1 = 0
    while eventPlayer.slot_1 < 5:
        startHealingModification(getPlayersInSlot(evalOnce(eventPlayer.slot_1), eventPlayer.getTeam()), eventPlayer, eventPlayer.HealingPercents[evalOnce(eventPlayer.slot_1)] * 100, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
        eventPlayer.HeroHealingModifications.append(getLastHealingModification())
        #BUG: Mercy's degeneration visual showing when the player in slot does not exist
        createInWorldText(eventPlayer if entityExists(getPlayersInSlot(evalOnce(eventPlayer.slot_1), eventPlayer.getTeam())) else null, "[{0}{1}%]\n".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), eventPlayer.HealingPercents[evalOnce(eventPlayer.slot_1)] * 100), getPlayersInSlot(evalOnce(eventPlayer.slot_1), eventPlayer.getTeam()), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
        eventPlayer.HeroTexts.append(getLastCreatedText())
        eventPlayer.slot_1 += 1
    eventPlayer.disallowButton(Button.ABILITY_2)
    #Create Hud
    hudSubtext(eventPlayer, "{0}({1})".format(" \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n \r\n {0}".format("                                                                                                                            {0}".format("                                                                                                                            {0}".format("                                                                                             " if eventPlayer.isInAlternateForm() else "                                                                     "))), "Blessing"), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.HeroTexts.append(getLastCreatedText())
    async(CleanupMercy, AsyncBehavior.NOOP)


rule "[mercy.del] Initial":
    @Event eachPlayer
    @Hero mercy
    
    InitialMercy()

rule "[mercy.del] Initial (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MERCY
    
    InitialMercy()
