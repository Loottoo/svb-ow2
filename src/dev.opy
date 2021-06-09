#!mainFile "main.opy"

globalvar devMode

rule "Init":
    devMode = createWorkshopSetting(bool, "Dev", "Enable dev mode", true, 0)


rule "------- testing  create bots":
    @Condition devMode
    
    wait(2)
    createDummy(Hero.ANA, Color.TEAM_1, -1, vect(0, 0, 0), vect(0, 0, 0))
    createDummy(Hero.ROADHOG, Color.TEAM_2, -1, vect(3, 0, 0), vect(0, 0, 0))
    createDummy(Hero.ANA, Color.TEAM_1, -1, vect(-3, 0, 0), vect(0, 0, 0))
    createDummy(Hero.WINSTON, Color.TEAM_1, -1, vect(3, 0, 3), vect(0, 0, 0))


rule "Spawn bots - For debugging":
    @Event eachPlayer
    @Condition devMode
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    createDummy(random.choice(getAllHeroes()), getOppositeTeam(eventPlayer.getTeam()), -1, eventPlayer + eventPlayer.getFacingDirection() * 0.5, eventPlayer.getFacingDirection())
    wait(1)
        ([player for player in getAllPlayers() if player != eventPlayer]).forceButtonPress(Button.INTERACT)


rule "Respawn faster":
    @Event eachPlayer
    @Condition devMode
    @Condition eventPlayer.isDummy() != true
    
    eventPlayer.setRespawnTime(1)


rule "Swap hero with key combo":
    @Event eachPlayer
    @Condition devMode
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getCurrentHero()))
    wait(0.25)
    eventPlayer.resetHeroAvailability()


rule "Dev HUD elements":
    @Condition devMode

    hudSubheader(getAllPlayers(), "Load: {0} - Avg: {1} - Peak: {2}".format(getServerLoad(), getAverageServerLoad(), getServerLoad()), HudPosition.TOP, 5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubheader(getAllPlayers(), "Change hero - Jump + Reload + Crouch", HudPosition.TOP, 6, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubheader(getAllPlayers(), "Spawn bot - Crouch + Interact", HudPosition.TOP, 7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Set Ult charge":
    @Event eachPlayer
    @Condition eventPlayer.getUltCharge() < 100
    
    eventPlayer.setUltCharge(100)
    wait(5)
    if RULE_CONDITION:
        goto RULE_START
