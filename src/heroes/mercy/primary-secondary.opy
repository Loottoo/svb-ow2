#!mainFile "../../main.opy"


def MercyDegenerateBeam():
    @Name "[mercy.del] Subroutine: Degenerate Healing Beam"
    
    eventPlayer.HealingPercents[healee.getSlot()] = max(eventPlayer.HealingPercents[healee.getSlot()] - 0.07, 0.727)
    eventPlayer.LastMercyTarget = getPlayersInSlot(healee.getSlot(), eventPlayer.getTeam())
    wait(1)


rule "[mercy.del] Degenerate Healing Beam":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventHealing > 0
    @Condition healer != healee
    @Condition (not eventPlayer.isUsingUltimate()) == true
    
    MercyDegenerateBeam()


def MercyRegenerateBeam():
    @Name "[mercy.del] Subroutine: Regenerate Healing Beam"
    
    eventPlayer.HealingPercents = [1 for player in eventPlayer.HealingPercents] if eventPlayer.isUsingUltimate() else [min(player + 0.07, 1) if eventPlayer.DegenerationEnabled[i] == false else player for player, i in eventPlayer.HealingPercents]
    wait(1)
    if RULE_CONDITION:
        goto RULE_START


rule "[mercy.del] Regenerate Healing Beam":
    @Event eachPlayer
    @Hero mercy
    
    MercyRegenerateBeam()


def MercyUpdateDegeneration():
    @Name "[mercy.del] Subroutine: Update Degeneration"
    
    healer.DegenerationEnabled[healee.getSlot()] = true
    wait(0.9)
    if healer.LastMercyTarget == eventPlayer:
        if healer.LastMercyTarget == eventPlayer and healer.isFiringSecondaryFire():
            goto RULE_START
    else:
        if (((sorted([i for i in getPlayersInRadius(healer.getEyePosition(), 15, healer.getTeam(), LosCheck.SURFACES).exclude(healer).exclude(getDeadPlayers(Team.ALL)) if healer.isInViewAngle(i, 360) and (not (healer.getCurrentHero() == Hero.SOMBRA and eventPlayer.isUsingAbility1())) and (not ((i.getCurrentHero() in ForbiddenUltimateHeroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingUltimate() or ((i.getCurrentHero() in ForbiddenAbility1Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility1()) or ((i.getCurrentHero() in ForbiddenAbility2Heroes or i.getHeroOfDuplication() in ForbiddenUltimateHeroes) and i.isUsingAbility2())))], lambda i: angleBetweenVectors(healer.getFacingDirection(), directionTowards(healer.getEyePosition(), i.getEyePosition())) + distance(healer.getEyePosition(), i.getEyePosition())))[0]) == eventPlayer) and healer.isFiringSecondaryFire():
            goto RULE_START
    healer.DegenerationEnabled[healee.getSlot()] = false


rule "[mercy.del] Update Degeneration":
    @Event playerReceivedHealing
    @Condition (healer.getCurrentHero() == Hero.MERCY or healer.getHeroOfDuplication() == Hero.MERCY) == true
    @Condition healer != healee
    @Condition (not healer.isUsingUltimate()) == true
    
    MercyUpdateDegeneration()


def MercyClearLastTarget():
    @Name "[mercy.del] Subroutine: Clear Last Target"
    
    waitUntil(not eventPlayer.isFiringPrimaryFire() and not eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingUltimate(), 9999)
    eventPlayer.LastMercyTarget = null


rule "[mercy.del] Clear Last Target":
    @Event eachPlayer
    @Hero mercy
    @Condition (not eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    MercyClearLastTarget()


rule "[mercy.del] Degenerate Healing Beam (Duplication)":
    @Event playerDealtHealing
    @Hero echo
    @Condition eventHealing > 0
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MERCY
    @Condition healer != healee
    @Condition (not eventPlayer.isUsingUltimate()) == true
    
    MercyDegenerateBeam()


rule "[mercy.del] Regenerate Healing Beam (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MERCY
    
    MercyRegenerateBeam()


rule "[mercy.del] Clear Last Target (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MERCY
    @Condition (not eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    MercyClearLastTarget()


rule "[mercy.del] Angelic Blessing (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MERCY
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    MercyAngelicBlessing()
