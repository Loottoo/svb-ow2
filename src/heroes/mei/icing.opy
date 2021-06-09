#!mainFile "../../main.opy"


globalvar IcingMaxRange
globalvar IcingSteps
globalvar IcingRadius
globalvar IcingDuration
globalvar IcingCooldown
globalvar IcingOverwritesButton
globalvar IcingMinSpeed
globalvar IcingMaxSpeed
globalvar IcingDamageOnImpact
globalvar IcingSlow
globalvar IcingFreezeOnImpact
globalvar IcingSpeedIncrease
globalvar IcingType


playervar IcingEffects
playervar IcingCreateStep
playervar IcingEndPosition
playervar IcingStartPosition
playervar IcingStepPositions
playervar IcingCurrentSpeed
playervar IcingSnowballEffect
playervar IcingActiveCooldown
playervar IcingPlayersDamaged
playervar IcingPlayersToDamage
playervar InIcingOfPlayer


subroutine ClearIcing
subroutine ChaseIcingSpeed
subroutine IcingFreezeAndDamageOnImpact


rule "Initialise Icing":
  #Workshop setting that determines what button icing will use, opening this action might be laggy.
  IcingOverwritesButton = createWorkshopSetting(enum["None", "Primary Fire", "Secondary Fire", "Ability 1 (Cryofreeze)", "Ability 2 (Ice Wall)"], "Mei - Icing ability", "What button should Icing overwrite?", 0, -10)
  #Set the variable from the combo index to the actual button
  IcingOverwritesButton = OverwriteButtonArray[IcingOverwritesButton]
  #Max range
  IcingMaxRange = createWorkshopSetting(float[5:50], "Mei - Icing ability", "Icing max range", 20, 3)
  #Icing steps (more = more accurate, but more effects used)
  IcingSteps = createWorkshopSetting(int[5:50], "Mei - Icing ability", "Steps (Higher = more circles on the ground)", 20, 5)
  #Width of icing
  IcingRadius = createWorkshopSetting(float[0.5:5], "Mei - Icing ability", "Icing radius (width)", 1.5, 4)
  #Duration of icing
  IcingDuration = createWorkshopSetting(float[0:20], "Mei - Icing ability", "Icing Duration", 5, 2)
  #Cooldown of icing
  IcingCooldown = createWorkshopSetting(float[0:100], "Mei - Icing ability", "Icing Cooldown", 10, 1)
  #Icing min player speed
  IcingMinSpeed = createWorkshopSetting(int[100:400], "Mei - Icing ability", "Minimum speed when standing on icing (Percentage relative to regular move speed)", 200, 6)
  #Icing max player speed
  IcingMaxSpeed = createWorkshopSetting(int[200:500], "Mei - Icing ability", "Maximum speed when standing on icing (Percentage relative to regular move speed)", 300, 7)
  #Icing damage on impact
  IcingDamageOnImpact = createWorkshopSetting(int[0:200], "Mei - Icing ability", "Damage on impact of initial Icing hit", 0, 8)
  #Icing freeze on impact
  IcingFreezeOnImpact = createWorkshopSetting(float[0:3], "Mei - Icing ability", "Freeze duration on impact of initial Icing hit", 0, 9)
  #Set how icing is used
  IcingType = createWorkshopSetting(enum["Create a straight path that \"slides\" teammates from point X to point Y", "Create a straight path that grants a static movement speed buff to teammates"], "Mei - Icing ability", "Icing type - How does Icing function?", 0, -1)
  #Icing slow
  IcingSlow = createWorkshopSetting(int[0:100], "Mei - Icing ability", "Slow for enemies walking over icing", 0, 20)
  #Movement increase for teammates walking on Icing (if Icing type is set to option 2)
  IcingSpeedIncrease = createWorkshopSetting(int[0:200], "Mei - Icing ability", "Movement increase for teammates walking on Icing (if Icing type is set to option 2)", 15, 21)


rule "Icing Cooldown HUD if icing is on Primary or Secondary fire":
  @Event eachPlayer
  @Hero mei
  @Condition IcingOverwritesButton != null
  @Condition (IcingOverwritesButton == Button.PRIMARY_FIRE or IcingOverwritesButton == Button.SECONDARY_FIRE) == true
  
  hudText([i for i in eventPlayer if eventPlayer.getCurrentHero() == Hero.MEI and true], null, " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.RIGHT, 99, null, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
  hudHeader([i for i in eventPlayer if eventPlayer.getCurrentHero() == Hero.MEI and true], "Icing: {0}".format(eventPlayer.IcingActiveCooldown), HudPosition.RIGHT, 100, Color.RED if eventPlayer.IcingActiveCooldown else Color.AQUA, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)


rule "Disable original Ability":
  @Event eachPlayer
  @Condition IcingOverwritesButton != null
  @Condition eventPlayer.getCurrentHero() == Hero.MEI
  
  if IcingOverwritesButton != Button.PRIMARY_FIRE:
    eventPlayer.disallowButton(IcingOverwritesButton)


rule "Presses Ability":
  @Event eachPlayer
  @Condition IcingOverwritesButton != null
  @Condition eventPlayer.getCurrentHero() == Hero.MEI
  @Condition eventPlayer.isAlive() == true
  @Condition ((IcingOverwritesButton == Button.PRIMARY_FIRE and eventPlayer.isFiringPrimaryFire()) or (IcingOverwritesButton != Button.PRIMARY_FIRE and eventPlayer.isHoldingButton(IcingOverwritesButton))) == true
  @Condition eventPlayer.getAbilityCooldown(IcingOverwritesButton) == 0
  @Condition eventPlayer.IcingActiveCooldown == 0
  @Condition eventPlayer.IsUsingAvalanche != true

  if IcingOverwritesButton == Button.PRIMARY_FIRE:
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) + 1)
  
  #Set cooldown of button used for Icing
  eventPlayer.setAbilityCooldown(IcingOverwritesButton, IcingCooldown)
  eventPlayer.IcingActiveCooldown = IcingCooldown
  eventPlayer.IcingPlayersDamaged = []
  chase(eventPlayer.IcingActiveCooldown, 0, duration=IcingCooldown, ChaseReeval.DESTINATION_AND_DURATION)
  #Communite, for extra flare
  eventPlayer.communicate(Comms.GOING_IN)
  #Reset icing
  eventPlayer.IcingEffects = []
  eventPlayer.IcingStepPositions = []
  #set the start of icing right in front of the player
  eventPlayer.IcingStartPosition = vect((eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (IcingRadius + 1))).x, eventPlayer.getEyePosition().y, (eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * (IcingRadius + 1))).z)
  #Set the end position, always at the same eye position as event player
  eventPlayer.IcingEndPosition = raycast(eventPlayer.getEyePosition(), vect((eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * IcingMaxRange).x, eventPlayer.getEyePosition().y, (eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * IcingMaxRange).z), null, null, false).getHitPosition()
  #Snowball!
  createEffect(getAllPlayers(), Effect.SPHERE, Color.SKY_BLUE, eventPlayer.IcingStepPositions.last() + Vector.UP * 3, 0.25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
  eventPlayer.IcingSnowballEffect = getLastCreatedEntity()
  playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
  #Loop to create effects and array for Icing location
  for eventPlayer.IcingCreateStep in range(0, IcingMaxRange, IcingMaxRange / IcingSteps):
      #Set position of next icing circle
      eventPlayer.IcingStepPositions = eventPlayer.IcingStepPositions.concat(eventPlayer.IcingStartPosition + directionTowards(eventPlayer.IcingStartPosition, eventPlayer.IcingEndPosition) * eventPlayer.IcingCreateStep)
      #Cast icing down in case we're going over slopes
      eventPlayer.IcingStepPositions[eventPlayer.IcingStepPositions.index(eventPlayer.IcingStepPositions.last())] = raycast(eventPlayer.IcingStepPositions.last(), eventPlayer.IcingStepPositions.last() + Vector.DOWN * 10, null, null, false).getHitPosition()
      #Slow enemies hit by the impact, if set by Workshop Setting
      async(IcingFreezeAndDamageOnImpact, AsyncBehavior.RESTART)
      #Create a bunch of cool effects at current position and save them to a variable
      createEffect(getAllPlayers(), Effect.RING, eventPlayer.getTeam(), eventPlayer.IcingStepPositions.last(), IcingRadius, EffectReeval.NONE)
      eventPlayer.IcingEffects = eventPlayer.IcingEffects.concat(getLastCreatedEntity())
      createEffect(getAllPlayers(), Effect.CLOUD, Color.WHITE, eventPlayer.IcingStepPositions.last() + Vector.DOWN * 0.25, IcingRadius, EffectReeval.NONE)
      eventPlayer.IcingEffects = eventPlayer.IcingEffects.concat(getLastCreatedEntity())
      createEffect(getAllPlayers(), Effect.SPARKLES, eventPlayer.getTeam(), eventPlayer.IcingStepPositions.last() + Vector.DOWN * 0.25, IcingRadius, EffectReeval.NONE)
      eventPlayer.IcingEffects = eventPlayer.IcingEffects.concat(getLastCreatedEntity())
      playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.getTeam(), eventPlayer.IcingStepPositions.last(), IcingRadius * 2)
      playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.WHITE, eventPlayer.IcingStepPositions.last(), IcingRadius * 2)
      playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, eventPlayer.getTeam(), eventPlayer.IcingStepPositions.last(), IcingRadius * 1)
      playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.IcingStepPositions.last(), 25)
      wait(0.032)
  destroyEffect(eventPlayer.IcingSnowballEffect)
  #Clear after delay (duration)
  wait(IcingDuration)
  ClearIcing()


rule "Icing is off cooldown":
  @Event eachPlayer
  @Condition eventPlayer.IcingActiveCooldown == 0

  if IcingOverwritesButton == Button.PRIMARY_FIRE:
    eventPlayer.allowButton(Button.PRIMARY_FIRE)


rule "Player is on Icing and Icing Type is set to slide":
  @Event eachPlayer
  @Condition IcingType == 0
  @Condition eventPlayer.isOnGround() == true
  @Condition (any([player != 0 and distance(player, eventPlayer.getPosition()) < IcingRadius for player in ([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() == Hero.MEI and len(player.IcingStepPositions) > 0]).IcingStepPositions])) == true
  
  eventPlayer.InIcingOfPlayer = ([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() == Hero.MEI and len(player.IcingStepPositions) > 0])[0]
  eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 1)
  #If player is facing end of icing and moving towards it
  if eventPlayer.getSpeedInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.InIcingOfPlayer.IcingStartPosition)) > eventPlayer.getSpeedInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.InIcingOfPlayer.IcingEndPosition)):
      #Accelerate towards end of icing
      eventPlayer.startAcceleration(directionTowards(eventPlayer.InIcingOfPlayer.IcingEndPosition, eventPlayer.InIcingOfPlayer.IcingStartPosition), 400, 200, Relativity.TO_WORLD, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
  else:
      #Accelerate towards start of icing
      eventPlayer.startAcceleration(directionTowards(eventPlayer.InIcingOfPlayer.IcingStartPosition, eventPlayer.InIcingOfPlayer.IcingEndPosition), 400, 200, Relativity.TO_WORLD, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
  ChaseIcingSpeed()


rule "Player is not on icing and Icing Type is set to slide":
  @Event eachPlayer
  @Condition IcingType == 0
  @Condition (any([player != 0 and distance(player, eventPlayer.getPosition()) < IcingRadius for player in ([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() == Hero.MEI]).IcingStepPositions])) == false
  
  wait(0.064)
  eventPlayer.stopAcceleration()
  eventPlayer.InIcingOfPlayer = null
  #Don't reset speed is using Avalanche
  if eventPlayer.IsUsingAvalanche != true:
      setRolePassiveMovementSpeed()
      eventPlayer.stopForcingThrottle()


rule "Speed up teammates walking on icing (if enabled)":
  @Event eachPlayer
  @Condition IcingType == 1
  @Condition (any([player != 0 and distance(player, eventPlayer.getPosition()) < IcingRadius for player in ([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() == Hero.MEI and len(player.IcingStepPositions) > 0]).IcingStepPositions])) == true
  
  eventPlayer.setMoveSpeed(rolePassivesDamageMovementspeed if eventPlayer.getCurrentHero() in getDamageHeroes() else 100 + IcingSpeedIncrease)
  wait(0.032)
  if RULE_CONDITION:
      goto RULE_START
  #Don't reset speed is using Avalanche
  if eventPlayer.IsUsingAvalanche != true:
      setRolePassiveMovementSpeed()


rule "Slow down enemies walking on icing (if enabled)":
  @Event eachPlayer
  @Condition IcingSlow > 0
  @Condition (any([player != 0 and distance(player, eventPlayer.getPosition()) < IcingRadius for player in ([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.getCurrentHero() == Hero.MEI and len(player.IcingStepPositions) > 0]).IcingStepPositions])) == true
  
  eventPlayer.setMoveSpeed(rolePassivesDamageMovementspeed if eventPlayer.getCurrentHero() in getDamageHeroes() else 100 - IcingSlow)
  wait(0.032)
  if RULE_CONDITION:
      goto RULE_START
  setRolePassiveMovementSpeed()


def ClearIcing():
  @Name "Subroutine - Clear Icing"
  
  #Clear icing and all of it's effects
  while len(eventPlayer.IcingEffects) > 0:
      destroyEffect(eventPlayer.IcingEffects[0])
      eventPlayer.IcingEffects = eventPlayer.IcingEffects.exclude(eventPlayer.IcingEffects[0])
      destroyEffect(eventPlayer.IcingEffects[0])
      eventPlayer.IcingEffects = eventPlayer.IcingEffects.exclude(eventPlayer.IcingEffects[0])
      destroyEffect(eventPlayer.IcingEffects[0])
      eventPlayer.IcingEffects = eventPlayer.IcingEffects.exclude(eventPlayer.IcingEffects[0])
      eventPlayer.IcingStepPositions = eventPlayer.IcingStepPositions.exclude(eventPlayer.IcingStepPositions[0])
      wait(0.032)
  #Set to empty, just in case
  eventPlayer.IcingStepPositions = []


def ChaseIcingSpeed():
  @Name "Subroutine - Chase Icing Speed"
  
  #Slowly accelerate player between a range
  for eventPlayer.IcingCurrentSpeed in range(IcingMinSpeed, IcingMaxSpeed, (IcingMaxSpeed - IcingMinSpeed) / 60):
      eventPlayer.setMoveSpeed(eventPlayer.IcingCurrentSpeed)
      wait(0.016, Wait.ABORT_WHEN_FALSE)


def IcingFreezeAndDamageOnImpact():
  @Name "Subroutine - Freeze and damage enemies on impact"
  
  #Freeze players in radius if freeze duration is set
  if IcingFreezeOnImpact > 0:
      getPlayersInRadius(eventPlayer.IcingStepPositions.last(), IcingRadius, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES).setStatusEffect(eventPlayer, Status.FROZEN, IcingFreezeOnImpact)
  #Damage players in radius if damage is set
  if IcingDamageOnImpact > 0:
      eventPlayer.IcingPlayersToDamage = [player for player in getPlayersInRadius(eventPlayer.IcingStepPositions.last(), IcingRadius, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) if player in eventPlayer.IcingPlayersDamaged != true]
      #Damage players in this radius and remove them from the array, continue until array is empty
      while len(eventPlayer.IcingPlayersToDamage) > 0:
          damage(eventPlayer.IcingPlayersToDamage.last(), eventPlayer, IcingDamageOnImpact)
          eventPlayer.IcingPlayersDamaged = eventPlayer.IcingPlayersDamaged.concat(eventPlayer.IcingPlayersToDamage.last())
          eventPlayer.IcingPlayersToDamage = eventPlayer.IcingPlayersToDamage.exclude(eventPlayer.IcingPlayersToDamage.last())

