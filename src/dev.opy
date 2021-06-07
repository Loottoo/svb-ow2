#!mainFile "main.opy"

globalvar devMode

rule "Init":
    devMode = createWorkshopSetting(bool, "Dev", "Enable dev mode", true, 0)


rule "------- testing  create bots":
    @Condition devMode
    @Condition hostPlayer.hasSpawned() == true
    
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
