#!mainFile "../main.opy"

#!define allowedHeroes(player) (getTankHeroes() if (player).getSlot() == 0 else getDamageHeroes() if (player).getSlot() < 3 else getSupportHeroes())

rule "Force players to always have only heroes in their role available":
    @Event eachPlayer
    @Condition any([not(hero in allowedHeroes(eventPlayer)) for hero in eventPlayer.getAllowedHeroes()])

    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(getAllHeroes().exclude(allowedHeroes(eventPlayer))))
    wait()
    if RULE_CONDITION:
        goto RULE_START
