#!mainFile "../../main.opy"


rule "[mercy.del] Degenerate Healing Beam":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventHealing > 0
    @Condition healer != healee
    @Condition (not eventPlayer.isUsingUltimate()) == true

    eventPlayer.HealingPercents[healee.getSlot()] = max(eventPlayer.HealingPercents[healee.getSlot()] - 0.07, 0.727)
    eventPlayer.LastMercyTarget = getPlayersInSlot(healee.getSlot(), eventPlayer.getTeam())
    wait(1)


rule "[mercy.del] Regenerate Healing Beam":
    @Event eachPlayer
    @Hero mercy

    eventPlayer.HealingPercents = [1 for player in eventPlayer.HealingPercents] if eventPlayer.isUsingUltimate() else [min(player + 0.07, 1) if eventPlayer.DegenerationEnabled[i] == false else player for player, i in eventPlayer.HealingPercents]
    wait(1)
    if RULE_CONDITION:
        goto RULE_START


rule "[mercy.del] Update Degeneration":
    @Event playerReceivedHealing
    @Condition (healer.getCurrentHero() == Hero.MERCY) == true
    @Condition healer != healee
    @Condition (not healer.isUsingUltimate()) == true

    healer.DegenerationEnabled[healee.getSlot()] = true
    wait(0.9)
    if healer.LastMercyTarget == eventPlayer:
        if healer.LastMercyTarget == eventPlayer and healer.isFiringSecondaryFire():
            goto RULE_START
    else:
        if (((sorted(
            [
                i for i in getPlayersInRadius(healer.getEyePosition(), 15, healer.getTeam(), LosCheck.SURFACES).exclude(healer).exclude(getDeadPlayers(Team.ALL))
                if not (
                    ((i.getCurrentHero() in ForbiddenUltimateHeroes) and i.isUsingUltimate())
                    or ((i.getCurrentHero() in ForbiddenAbility1Heroes) and i.isUsingAbility1())
                    or ((i.getCurrentHero() in ForbiddenAbility2Heroes) and i.isUsingAbility2())
                )
            ], lambda i: angleBetweenVectors(healer.getFacingDirection(), directionTowards(healer.getEyePosition(), i.getEyePosition())) + distance(healer.getEyePosition(), i.getEyePosition())
        ))[0]) == eventPlayer) and healer.isFiringSecondaryFire():
            goto RULE_START
    healer.DegenerationEnabled[healee.getSlot()] = false


rule "[mercy.del] Clear Last Target":
    @Event eachPlayer
    @Hero mercy
    @Condition (not eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isFiringSecondaryFire() == true

    waitUntil(not eventPlayer.isFiringPrimaryFire() and not eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingUltimate(), 9999)
    eventPlayer.LastMercyTarget = null
