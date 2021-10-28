#!mainFile "../../main.opy"


def CleanupReinhardt():
    @Name "[reinhardt.del] Subroutine: Cleanup"

    CleanupHealthPools()
    CleanupTexts()
    eventPlayer.setMaxHealth(100)
    eventPlayer.setAbility2Enabled(true)
    stopChasingVariable(eventPlayer.ReinhardtFirestrikeCooldown)
    eventPlayer.stopAcceleration()


def InitialReinhardt():
    @Name "[reinhardt.del] Subroutine: Initial"

    #Variable setup
    eventPlayer.ReinhardtFirestrikeCharges = 2
    eventPlayer.ReinhardtFirestrikeCooldown = 0
    chase(eventPlayer.ReinhardtFirestrikeCooldown, 0, rate=1, ChaseReeval.NONE)
    #Character setup
    eventPlayer.setMaxHealth(75)
    eventPlayer.addHealthPool(Health.NORMAL, 25, true, true)
    eventPlayer.HeroHealthPools.append(getLastCreatedHealthPool())
    eventPlayer.addHealthPool(Health.ARMOR, 200, true, true)
    eventPlayer.HeroHealthPools.append(getLastCreatedHealthPool())
    hudSubtext(eventPlayer, "{0}({1}) [{2}]".format(" \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n                                                                                                                                                                                                                                                                                                                                  ", floor(eventPlayer.ReinhardtFirestrikeCharges) if floor(eventPlayer.ReinhardtFirestrikeCharges) > 0 else iconString(Icon.CROSS), iconString(Icon.CHECKMARK) if floor(eventPlayer.ReinhardtFirestrikeCharges) == 2 else ceil(eventPlayer.ReinhardtFirestrikeCooldown)), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.HeroTexts.append(getLastCreatedText())


rule "[reinhardt.del] Boost all damage that isn't firestrike":
    @Event playerDealtDamage
    @Condition eventPlayer.hero == Hero.Reinhardt
    @Condition eventAbility != null and eventAbility != Button.ABILITY_2

    damage(victim, attacker, eventDamage * 10 / 9)
