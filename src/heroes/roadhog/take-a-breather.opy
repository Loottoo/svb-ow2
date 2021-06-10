#!mainFile "../../main.opy"


globalvar roadhogBreatherCloudSize = createWorkshopSetting(float[1:50], "Roadhog", "Take a breather cloud size", 7.5, 0)



playervar roadhogCloudEntity
playervar roadhogMovementSpeed
playervar roadhogCloudPos
playervar roadhogCloudPlayersAffected
playervar roadhogCloudDamageMod


subroutine RoadhogTakeABreather
subroutine RoadhogCloudHealing


rule "[Roadhog] Take a breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2() == true
    
    async(RoadhogTakeABreather, AsyncBehavior.NOOP)


rule "[Roadhog]§ Take a breather":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.ROADHOG
    @Condition eventPlayer.isUsingAbility2() == true
    
    async(RoadhogTakeABreather, AsyncBehavior.NOOP)


def RoadhogTakeABreather():
    @Name "[Sub][Roadhog] Take a breather"
    
    eventPlayer.roadhogCloudPlayersAffected = []
    eventPlayer.roadhogCloudEntity = []
    eventPlayer.roadhogCloudPos = eventPlayer.getPosition()
    startDamageModification(eventPlayer.roadhogCloudPlayersAffected, getAllPlayers(), 100 - createWorkshopSetting(int[0:100], "Roadhog", "Cloud damage reduction (%)", 10, 3), DamageReeval.NONE)
    eventPlayer.roadhogCloudDamageMod = getLastDamageModification()
    for eventPlayer.Index in range(-0.5, 1):
        createEffect(getPlayers(eventPlayer.getTeam()), Effect.CLOUD, Color.YELLOW, evalOnce(eventPlayer.getPosition() + vect(0.5, 0, 0.5) * eventPlayer.Index), roadhogBreatherCloudSize * 1.15, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.roadhogCloudEntity.append(getLastCreatedEntity())
        createEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())), Effect.CLOUD, Color.TURQUOISE, evalOnce(eventPlayer.getPosition() + vect(0.5, 0, 0.5) * eventPlayer.Index), roadhogBreatherCloudSize * 1.1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.roadhogCloudEntity.append(getLastCreatedEntity())
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, eventPlayer.roadhogCloudPos, roadhogBreatherCloudSize, EffectReeval.VISIBILITY)
    eventPlayer.roadhogCloudEntity.append(getLastCreatedEntity())
    eventPlayer.roadhogMovementSpeed = 100
    chase(eventPlayer.roadhogMovementSpeed, 0, duration=1.5, ChaseReeval.DESTINATION_AND_DURATION)
    while eventPlayer.roadhogMovementSpeed != 0:
        eventPlayer.setMoveSpeed(eventPlayer.roadhogMovementSpeed)
        wait(0.032)
    chase(eventPlayer.roadhogMovementSpeed, 100, duration=1, ChaseReeval.DESTINATION_AND_DURATION)
    while eventPlayer.roadhogMovementSpeed != 100:
        eventPlayer.setMoveSpeed(eventPlayer.roadhogMovementSpeed)
        wait(0.032)
    eventPlayer.setMoveSpeed(100)
    wait(createWorkshopSetting(float[2.5:9], "Roadhog", "Cloud duration", 6, 1) - 2.5)
    for eventPlayer.Index in range(len(eventPlayer.roadhogCloudEntity)):
        destroyEffect(eventPlayer.roadhogCloudEntity[eventPlayer.Index])
    stopDamageModification(eventPlayer.roadhogCloudDamageMod)
    eventPlayer.roadhogCloudEntity = []


rule "[Roadhog] Cloud healing":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.roadhogCloudEntity != []
    
    RoadhogCloudHealing()
    wait(1)
    if RULE_CONDITION:
        goto RULE_START


rule "[Roadhog]§ Cloud healing":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.ROADHOG
    @Condition eventPlayer.roadhogCloudEntity != []
    
    RoadhogCloudHealing()
    wait(1)
    if RULE_CONDITION:
        goto RULE_START


def RoadhogCloudHealing():
    @Name "[Sub][Roadhog] Cloud healing"
    
    eventPlayer.roadhogCloudPlayersAffected = getPlayersInRadius(eventPlayer.roadhogCloudPos, roadhogBreatherCloudSize, eventPlayer.getTeam(), LosCheck.SURFACES)
    eventPlayer.roadhogCloudPlayersAffected.startHoT(eventPlayer, 1, createWorkshopSetting(int[0:100], "Roadhog", "Cloud Healing per second", 10, 2))


