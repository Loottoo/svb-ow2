#!mainFile "../../main.opy"


globalvar speedboostMaxGain = createWorkshopSetting(int[1:100], "Lucio", "Speedboost max extra by Music Meter", 20, 2)
globalvar speedboostMinGain = createWorkshopSetting(int[1:100], "Lucio", "Speedboost min extra by Music Meter", 5, 3)


rule "[lucio.del] Speedboost":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isInAlternateForm() == true
    
    eventPlayer.SpeedboostBonus = speedboostMinGain * (1 - eventPlayer.MusicMeter / 100) + speedboostMaxGain * (eventPlayer.MusicMeter / 100) if eventPlayer.MusicMeter >= musicMeterGain else 0
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)

rule "[lucio.del] Player affected by Speedboost":
    @Event eachPlayer
    @Condition (any([player.isUsingAbility2() and player.isInAlternateForm() and distance(player, eventPlayer) <= 12 for player in getPlayersOnHero(Hero.LUCIO, eventPlayer.getTeam())])) == true
    
    wait()
    eventPlayer.LucioBoost = ([player for player in getPlayersOnHero(Hero.LUCIO, eventPlayer.getTeam()) if player.isUsingAbility2() and distance(player, eventPlayer) <= 12])[0]
    eventPlayer.AddSpeedMod += eventPlayer.LucioBoost.SpeedboostBonus
    waitUntil(not (any([player.isUsingAbility2() and player.isInAlternateForm() and distance(player, eventPlayer) <= 12 for player in getPlayersOnHero(Hero.LUCIO, eventPlayer.getTeam())])), 99999)
    if (eventPlayer.LucioBoost.isUsingAbility2() and eventPlayer.isInAlternateForm()):
        waitUntil(any([player.isUsingAbility2() and player.isInAlternateForm() and distance(player, eventPlayer) <= 12 for player in getPlayersOnHero(Hero.LUCIO, eventPlayer.getTeam())]), 1)
    eventPlayer.AddSpeedMod -= eventPlayer.LucioBoost.SpeedboostBonus
    eventPlayer.LucioBoost = false
    if RULE_CONDITION:
        goto RULE_START
