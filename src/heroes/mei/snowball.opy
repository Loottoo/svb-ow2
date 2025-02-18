#!mainFile "../../main.opy"

globalvar SnowballFlySpeed
globalvar SnowballGravityStrength
globalvar SnowballDamage
globalvar SnowballEnabled
globalvar SnowballDelay
globalvar SnowballDamageAoE
globalvar SnowballAoERadius


playervar SnowballRaycastFire
playervar SnowballShootLoop
playervar SnowballCurrentCheckPosition
playervar SnowballsFlying
playervar SnowballRaycastDistance
playervar SnowballPreviousPosition
playervar SnowballFacingDirection
playervar SnowballEyeLocationWhenFired
playervar SnowballFinalPosition
playervar SnowballEffects
playervar SnowballLoop


subroutine CreateSnowballEffects
subroutine DestroyCurrentSnowball
subroutine AddSnowball
subroutine SnowballDamage


rule "Initialise":
    SnowballEnabled = createWorkshopSetting(bool, "Mei - Snowball secondary fire", "Enable Snowball instead of regular right click", false, -1)
    SnowballFlySpeed = createWorkshopSetting(float[0.1:5], "Mei - Snowball secondary fire", "Snowball fly speed", 1.5, 0)
    SnowballDelay = createWorkshopSetting(float[0.1:1], "Mei - Snowball secondary fire", "Snowball time between shots", 0.2, 0)
    SnowballGravityStrength = 1 + createWorkshopSetting(int[1:10], "Mei - Snowball secondary fire", "Snowball gravity strength (how quick the ball falls down)", 4, 0) * 0.01
    SnowballDamage = createWorkshopSetting(int[0:200], "Mei - Snowball secondary fire", "Snowball damage done", 100, 2)
    SnowballDamageAoE = createWorkshopSetting(int[0:200], "Mei - Snowball secondary fire", "Snowball AOE damage done", 50, 3)
    SnowballAoERadius = createWorkshopSetting(float[0:5], "Mei - Snowball secondary fire", "Snowball AoE Radius", 2, 4)
    getAllPlayers().SnowballEffects = []


rule "Initialise player":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.MEI
    @Condition SnowballEnabled == true
    
    eventPlayer.SnowballEffects = []
    eventPlayer.SnowballRaycastDistance = []
    eventPlayer.SnowballPreviousPosition = []
    eventPlayer.SnowballEyeLocationWhenFired = []
    eventPlayer.SnowballFinalPosition = []
    eventPlayer.SnowballShootLoop = []


rule "Press Secondary, Interrupt original secondary fire and replace with snowball":
    @Event eachPlayer
    @Condition SnowballEnabled == true
    @Condition eventPlayer.getCurrentHero() == Hero.MEI
    @Condition eventPlayer.isReloading() != true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    wait(0.3)
    #Cancel full charge of secondary fire
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    #Create a snowball
    AddSnowball()
    wait(SnowballDelay)
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 2)
    if SeparateAmmoEnabled and eventPlayer.CurrentAmmoSecondary > 0 or not SeparateAmmoEnabled:
        #Re-enable secondary fire
        eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)


rule "Loop through all currently active snowballs":
    @Event eachPlayer
    @Condition eventPlayer.SnowballsFlying > 0
    
    #Set variable to reference previous positions later
    eventPlayer.SnowballPreviousPosition = eventPlayer.SnowballCurrentCheckPosition
    #Add 1 to all "shoot loop" elements in array
    eventPlayer.SnowballShootLoop = [player + 1 for player in eventPlayer.SnowballShootLoop]
    #Set new position for all elements in array
    eventPlayer.SnowballCurrentCheckPosition = [eventPlayer.SnowballEyeLocationWhenFired[i] + eventPlayer.SnowballFacingDirection[i] * eventPlayer.SnowballShootLoop[i] * SnowballFlySpeed + (vect(0, SnowballGravityStrength - SnowballGravityStrength ** eventPlayer.SnowballShootLoop[i] - (SnowballGravityStrength - 1), 0)) for _, i in eventPlayer.SnowballCurrentCheckPosition]
    #Loop over all elements in array to check if snowball hit something
    for eventPlayer.SnowballLoop in range(eventPlayer.SnowballsFlying):
        #If distance between previous position and new position is less than expected amount it hit something
        if distance(eventPlayer.SnowballPreviousPosition[eventPlayer.SnowballLoop], raycast(eventPlayer.SnowballPreviousPosition[eventPlayer.SnowballLoop], eventPlayer.SnowballCurrentCheckPosition[eventPlayer.SnowballLoop], getPlayers(getOppositeTeam(eventPlayer.getTeam())), eventPlayer, true).getHitPosition()) < distance(eventPlayer.SnowballPreviousPosition[eventPlayer.SnowballLoop], eventPlayer.SnowballCurrentCheckPosition[eventPlayer.SnowballLoop]):
            #Set final position to be used for damage checks
            eventPlayer.SnowballFinalPosition = raycast(eventPlayer.SnowballPreviousPosition[eventPlayer.SnowballLoop], eventPlayer.SnowballCurrentCheckPosition[eventPlayer.SnowballLoop], getPlayers(getOppositeTeam(eventPlayer.getTeam())), eventPlayer, true).getHitPosition()
            #Play a bunch of effects at the final location
            playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, evalOnce(eventPlayer.SnowballCurrentCheckPosition[eventPlayer.SnowballLoop]), 50)
            playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, eventPlayer.getTeam(), evalOnce(eventPlayer.SnowballCurrentCheckPosition[eventPlayer.SnowballLoop]), SnowballAoERadius)
            playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, evalOnce(eventPlayer.SnowballCurrentCheckPosition[eventPlayer.SnowballLoop]), SnowballAoERadius * 0.95)
            #Deal damage to players hit or near final position
            SnowballDamage()
            #Remove snowball from array and destroy its effects
            DestroyCurrentSnowball()
    wait()
    if RULE_CONDITION:
        goto RULE_START


def AddSnowball():
    @Name "Subroutine - Add snowball"
    
    eventPlayer.SnowballsFlying += 1
    CreateSnowballEffects()
    eventPlayer.SnowballFacingDirection[evalOnce(eventPlayer.SnowballsFlying - 1)] = eventPlayer.getFacingDirection()
    eventPlayer.SnowballEyeLocationWhenFired[evalOnce(eventPlayer.SnowballsFlying - 1)] = eventPlayer.getEyePosition()
    eventPlayer.SnowballRaycastFire[evalOnce(eventPlayer.SnowballsFlying - 1)] = raycast(eventPlayer.SnowballEyeLocationWhenFired[evalOnce(eventPlayer.SnowballsFlying - 1)], eventPlayer.SnowballEyeLocationWhenFired[evalOnce(eventPlayer.SnowballsFlying - 1)] + ((eventPlayer.getFacingDirection() + normalize(Vector.UP)) * 100), null, getAllPlayers(), false).getHitPosition()
    eventPlayer.SnowballRaycastDistance[evalOnce(eventPlayer.SnowballsFlying - 1)] = 100
    eventPlayer.SnowballCurrentCheckPosition[evalOnce(eventPlayer.SnowballsFlying - 1)] = eventPlayer.getEyePosition()
    eventPlayer.SnowballShootLoop[evalOnce(eventPlayer.SnowballsFlying - 1)] = 0


def CreateSnowballEffects():
    @Name "Subroutine - Create snowball effects"
    
    createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, eventPlayer.SnowballCurrentCheckPosition[evalOnce(eventPlayer.SnowballsFlying - 1)], 0.1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SnowballEffects = eventPlayer.SnowballEffects.concat(getLastCreatedEntity())
    createEffect(getAllPlayers(), Effect.SPARKLES, eventPlayer.getTeam(), eventPlayer.SnowballCurrentCheckPosition[evalOnce(eventPlayer.SnowballsFlying - 1)], 0.25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SnowballEffects = eventPlayer.SnowballEffects.concat(getLastCreatedEntity())
    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.WHITE, eventPlayer.SnowballCurrentCheckPosition[evalOnce(eventPlayer.SnowballsFlying - 1)], 0.15, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.SnowballEffects = eventPlayer.SnowballEffects.concat(getLastCreatedEntity())


def DestroyCurrentSnowball():
    @Name "Subroutine - Destroy current snowball"
    
    #Remove all values for current index from relevant arrays
    eventPlayer.SnowballRaycastDistance = [_ for _, i in eventPlayer.SnowballRaycastDistance if i != eventPlayer.SnowballLoop]
    eventPlayer.SnowballPreviousPosition = [_ for _, i in eventPlayer.SnowballPreviousPosition if i != eventPlayer.SnowballLoop]
    eventPlayer.SnowballCurrentCheckPosition = [_ for _, i in eventPlayer.SnowballCurrentCheckPosition if i != eventPlayer.SnowballLoop]
    eventPlayer.SnowballEyeLocationWhenFired = [_ for _, i in eventPlayer.SnowballEyeLocationWhenFired if i != eventPlayer.SnowballLoop]
    eventPlayer.SnowballFacingDirection = [_ for _, i in eventPlayer.SnowballFacingDirection if i != eventPlayer.SnowballLoop]
    eventPlayer.SnowballShootLoop = [_ for _, i in eventPlayer.SnowballShootLoop if i != eventPlayer.SnowballLoop]
    eventPlayer.SnowballsFlying -= 1
    #Destroy all effects related to this snowball
    destroyEffect(eventPlayer.SnowballEffects.last())
    eventPlayer.SnowballEffects = eventPlayer.SnowballEffects.exclude(eventPlayer.SnowballEffects.last())
    destroyEffect(eventPlayer.SnowballEffects.last())
    eventPlayer.SnowballEffects = eventPlayer.SnowballEffects.exclude(eventPlayer.SnowballEffects.last())
    destroyEffect(eventPlayer.SnowballEffects.last())
    eventPlayer.SnowballEffects = eventPlayer.SnowballEffects.exclude(eventPlayer.SnowballEffects.last())


def SnowballDamage():
    @Name "Subroutine - Damage players near snowball"
    
    #Damage closest player since that's very likely the one who got hit. Subtract the AoE damage since that will also be applied later.
    damage(
        raycast(
            eventPlayer.SnowballFinalPosition,
            eventPlayer.SnowballFinalPosition + directionTowards(
                eventPlayer.SnowballFinalPosition,
                getClosestPlayer(eventPlayer.SnowballFinalPosition, getOppositeTeam(eventPlayer.getTeam())).getEyePosition()
            ) * 0.2,
            getPlayers(getOppositeTeam(eventPlayer.getTeam())),
            eventPlayer,
            true
        ).getPlayerHit(),
        eventPlayer, # Player that dealt the damage
        SnowballDamage - SnowballDamageAoE # Damage dealt, impact minus AoE since we will also apply that later
    )
    #Damage all players in AoE range. We can't use Players In Radius since that use Position Of, rather than their actual hitbox.
    damage(
        [player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam()))
            if raycast(
                eventPlayer.SnowballFinalPosition,
                eventPlayer.SnowballFinalPosition + directionTowards(
                    eventPlayer.SnowballFinalPosition,
                    player.getEyePosition()
                ) * SnowballAoERadius,
                player,
                null,
                true
            ).getPlayerHit() == player
        ],
        eventPlayer,
        SnowballDamageAoE
    )

