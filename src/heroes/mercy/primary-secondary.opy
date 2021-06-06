#!mainFile "../../main.opy"

#Player variables

playervar Index
playervar index2
playervar mercyPlayersInRadius
playervar mercyBeamDistance
playervar mercyCheckPos
playervar mercyDamageMods
playervar mercyBeamTarget
playervar mercyBeaming
playervar mercyHealingMods


#Subroutine names

subroutine GetMercyBeamTarget
subroutine BeamTargetFound
subroutine BeamDistanceCheck


rule "[Mercy] is firing primary/secondary":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isAlive() == true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == true
    @Condition eventPlayer.mercyBeaming == false
    @Condition eventPlayer.getCurrentWeapon() == 1
    @Condition eventPlayer.isUsingUltimate() == true
    
    GetMercyBeamTarget()
    if (distance(eventPlayer.mercyBeamTarget, eventPlayer) <= (30.5 if eventPlayer.isUsingUltimate() else 15.5)) and eventPlayer.mercyBeamTarget != null:
        eventPlayer.mercyBeamTarget.startForcingOutlineFor(eventPlayer, true, Color.LIME_GREEN, OutlineVisibility.ALWAYS)
        eventPlayer.mercyBeaming = true
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "[Mercy]§§ is firing primary/secondary":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MERCY
    @Condition eventPlayer.isAlive() == true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == true
    @Condition eventPlayer.mercyBeaming == false
    @Condition eventPlayer.getCurrentWeapon() == 1
    @Condition eventPlayer.isUsingUltimate() == true
    
    GetMercyBeamTarget()
    if (distance(eventPlayer.mercyBeamTarget, eventPlayer) <= (30.5 if eventPlayer.isUsingUltimate() else 15.5)) and eventPlayer.mercyBeamTarget != null:
        eventPlayer.mercyBeamTarget.startForcingOutlineFor(eventPlayer, true, Color.LIME_GREEN, OutlineVisibility.ALWAYS)
        eventPlayer.mercyBeaming = true
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "[Mercy] not firing beam - Reset Target":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyBeaming == true
    @Condition (eventPlayer.getCurrentWeapon() == 2 or eventPlayer.isFiringPrimaryFire() == false and eventPlayer.isFiringSecondaryFire() == false) == true
    
    eventPlayer.mercyBeamTarget.stopForcingOutlineFor(eventPlayer)
    #Reset beam target
    eventPlayer.mercyBeamTarget = null
    eventPlayer.mercyBeaming = false


rule "[Mercy]§ not firing beam - Reset Target":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MERCY
    @Condition eventPlayer.mercyBeaming == true
    @Condition (eventPlayer.getCurrentWeapon() == 2 or eventPlayer.isFiringPrimaryFire() == false and eventPlayer.isFiringSecondaryFire() == false) == true
    
    eventPlayer.mercyBeamTarget.stopForcingOutlineFor(eventPlayer)
    #Reset beam target
    eventPlayer.mercyBeamTarget = null
    eventPlayer.mercyBeaming = false


rule "[Mercy] Beam distance check":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyBeaming == true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == true
    
    BeamDistanceCheck()


rule "[Mercy]§ Beam distance check":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyBeaming == true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == true
    
    BeamDistanceCheck()


def BeamDistanceCheck():
    @Name "[Sub][Mercy] Beam distance check"
    
    while distance(eventPlayer.mercyBeamTarget.getPosition(), eventPlayer.getPosition()) <= (30.5 if eventPlayer.isUsingUltimate() else 15.5):
        wait()
        waitUntil((distance(eventPlayer.mercyBeamTarget, eventPlayer) > (30.5 if eventPlayer.isUsingUltimate() else 15.5)) or eventPlayer.isFiringPrimaryFire() == false and eventPlayer.isFiringSecondaryFire() == false, 9999)
        waitUntil((distance(eventPlayer.mercyBeamTarget, eventPlayer) <= (30.5 if eventPlayer.isUsingUltimate() else 15.5)) or eventPlayer.isFiringPrimaryFire() == false and eventPlayer.isFiringSecondaryFire() == false, 1.264)
        if (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == false:
            break
    eventPlayer.mercyBeamTarget.stopForcingOutlineFor(eventPlayer)
    #Reset beam target
    #eventPlayer.mercyBeamTarget = null
    eventPlayer.mercyBeaming = false


rule "[Mercy] beam target found":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyBeaming == true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == true
    @Condition eventPlayer.isUsingUltimate() == true
    
    async(BeamTargetFound, AsyncBehavior.NOOP)


rule "[Mercy]§ beam target found":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MERCY
    @Condition eventPlayer.mercyBeaming == true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == true
    @Condition eventPlayer.isUsingUltimate() == true
    
    async(BeamTargetFound, AsyncBehavior.NOOP)


def BeamTargetFound():
    @Name "[Sub][Mercy] Beam target found"
    
    eventPlayer.mercyHealingMods = []
    eventPlayer.mercyDamageMods = []
    #Reduced healing to secondary targets
    startHealingModification([player for player in getPlayers(eventPlayer.getTeam()) if player != eventPlayer and player != eventPlayer.mercyBeamTarget], eventPlayer, createWorkshopSetting(int[0:300], "Mercy", "Valkyrie - Secondary targets heal percentage", 50, 1), HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
    eventPlayer.mercyHealingMods.append(getLastHealingModification())
    #Main target recieves more healing
    startHealingModification(eventPlayer.mercyBeamTarget, eventPlayer, createWorkshopSetting(int[50:300], "Mercy", "Valkyrie - Primary target heal percentage", 150, 0), HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
    eventPlayer.mercyHealingMods.append(getLastHealingModification())
    while eventPlayer.isUsingUltimate():
        while eventPlayer.isFiringSecondaryFire() and eventPlayer.mercyBeaming:
            #Reduce damage boost for secondary targets
            startDamageModification(getPlayers(getOppositeTeam(eventPlayer.getTeam())), [player for player in getPlayersInRadius(eventPlayer.mercyBeamTarget, 10.496, eventPlayer.getTeam(), LosCheck.SURFACES) if player != eventPlayer and player != eventPlayer.mercyBeamTarget], (createWorkshopSetting(int[0:100], "Mercy", "Valkyrie - Secondary targets damage boost", 15, 3) + 100) / 1.3, DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
            eventPlayer.mercyDamageMods.append(getLastDamageModification())
            #Increase damage boost for primary target
            startDamageModification(getPlayers(getOppositeTeam(eventPlayer.getTeam())), eventPlayer.mercyBeamTarget, (createWorkshopSetting(int[30:100], "Mercy", "Valkyrie - Primary target damage boost", 45, 2) + 100) / 1.3, DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
            eventPlayer.mercyDamageMods.append(getLastDamageModification())
            #waitUntil(eventPlayer.isFiringSecondaryFire() == false or eventPlayer.isUsingUltimate() == false, 15)
            waitUntil(eventPlayer.mercyBeaming == false or eventPlayer.isFiringSecondaryFire() == false or eventPlayer.isUsingUltimate() == false, 15)
            stopDamageModification(eventPlayer.mercyDamageMods[0])
            stopDamageModification(eventPlayer.mercyDamageMods[1])
            wait()
            eventPlayer.mercyDamageMods = []
        wait()
        waitUntil(eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingUltimate() == false, 15)
    stopHealingModification(eventPlayer.mercyHealingMods[0])
    stopHealingModification(eventPlayer.mercyHealingMods[1])
    eventPlayer.mercyBeamTarget.stopForcingOutlineFor(eventPlayer)


def GetMercyBeamTarget():
    @Name "[Sub][Mercy] Get Mercy Beam target"
    
    eventPlayer.mercyBeamTarget = null
    eventPlayer.mercyPlayersInRadius = getPlayersInRadius(eventPlayer.getPosition(), 30.5 if eventPlayer.isUsingUltimate() else 15.5, eventPlayer.getTeam(), LosCheck.SURFACES)
    eventPlayer.mercyPlayersInRadius = [player for player in eventPlayer.mercyPlayersInRadius if player != eventPlayer]
    eventPlayer.mercyPlayersInRadius = sorted(eventPlayer.mercyPlayersInRadius, lambda player: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), player.getPosition() + vect(0, 1.45, 0))) + distance(eventPlayer.getPosition(), player.getPosition()) * 0.406)
    wait(0.032)
    for eventPlayer.Index in range(len(eventPlayer.mercyPlayersInRadius)):
        eventPlayer.mercyBeamDistance = distance(eventPlayer.getPosition(), eventPlayer.mercyPlayersInRadius[eventPlayer.Index].getPosition())
        eventPlayer.mercyCheckPos = eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * eventPlayer.mercyBeamDistance
        for eventPlayer.index2 in range(1.505, -0.1, -0.15):
            if distance(eventPlayer.mercyCheckPos, eventPlayer.mercyPlayersInRadius[eventPlayer.Index].getPosition() + vect(0, eventPlayer.index2, 0)) <= 0.461 + 0.348 * eventPlayer.mercyBeamDistance:
                eventPlayer.mercyBeamTarget = eventPlayer.mercyPlayersInRadius[eventPlayer.Index]
                return



