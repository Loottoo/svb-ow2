#!mainFile "../../main.opy"

globalvar AvalancheRadius
globalvar AvalancheDuration
globalvar AvalancheMaxSpeed
globalvar AvalancheEnabled
globalvar AvalancheDamagePerTick
globalvar AvalancheDamageExplosion


playervar IsUsingAvalanche
playervar AvalancheEffects
playervar AvalancheLoop
playervar AvalancheSpeed
playervar AvalancheCurrentRadius
playervar AvalancheFacingDirection
playervar AvalancheFinalPosition
playervar PlayersInAvalanche
playervar AvalancheTimer


subroutine SetAvalancheCamera
subroutine ChaseAvalancheSpeed
subroutine ChaseAvalancheRadius
subroutine ClearAvalanche
subroutine ExplodeAvalanche
subroutine ExplodePlayersInAvalanche


rule "Initialise Avalanche":
  AvalancheEnabled = createWorkshopSetting(bool, "Avalanche ability (Ultimate)", "Enable Avalanche instead of regular Ultimate", true, 0)
  AvalancheRadius = createWorkshopSetting(float[1:3], "Avalanche ability (Ultimate)", "Avalanche Radius", 2, 1)
  AvalancheDuration = createWorkshopSetting(float[1:5], "Avalanche ability (Ultimate)", "Avalanche Duration", 3, 2)
  AvalancheMaxSpeed = createWorkshopSetting(int[100:400], "Avalanche ability (Ultimate)", "Avalanche max speed", 200, 3)
  AvalancheDamagePerTick = createWorkshopSetting(float[0:10], "Avalanche ability (Ultimate)", "Damage per tick while players are attached", 1.5, 4)
  AvalancheDamageExplosion = createWorkshopSetting(float[0:500], "Avalanche ability (Ultimate)", "Damage on explode", 50, 5)


rule "Avalanche Progress Bar HUD element":
  @Event eachPlayer
  @Hero mei
  @Condition AvalancheEnabled == true
  
  progressBarHud([i for i in eventPlayer if eventPlayer.IsUsingAvalanche], 100 / AvalancheDuration * eventPlayer.AvalancheTimer, "", HudPosition.TOP, 10, Color.AQUA, Color.AQUA, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)
  #New lines to push the progress bar down
  hudSubheader([i for i in eventPlayer if eventPlayer.IsUsingAvalanche], " \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n", HudPosition.TOP, 9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Disable original Ultimate":
  @Event eachPlayer
  @Hero mei
  @Condition AvalancheEnabled == true
  
  eventPlayer.disallowButton(Button.ULTIMATE)


rule "Player presses Ultimate":
  @Event eachPlayer
  @Hero mei
  @Condition AvalancheEnabled == true
  @Condition eventPlayer.isAlive() == true
  @Condition eventPlayer.getUltCharge() == 100
  @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
  @Condition eventPlayer.isUsingAbility1() != true
  @Condition eventPlayer.IsUsingAvalanche != true
  
  eventPlayer.IsUsingAvalanche = true
  #Set timer and chase it down
  eventPlayer.AvalancheTimer = AvalancheDuration
  chase(eventPlayer.AvalancheTimer, 0, duration=AvalancheDuration, ChaseReeval.DESTINATION_AND_DURATION)
  #Communicate, for fun
  eventPlayer.communicate(Comms.INCOMING)
  wait(AvalancheDuration + 0.5)
  eventPlayer.setUltCharge(0)


rule "Player is using Avalanche":
  @Event eachPlayer
  @Condition eventPlayer.IsUsingAvalanche == true
  
  #Set initial facing direction
  eventPlayer.AvalancheFacingDirection = eventPlayer.getFacingDirection()
  eventPlayer.PlayersInAvalanche = []
  #Set player to "Phased Out" so they don't collide with others and can't be hit, as well as clearing all debuffs
  eventPlayer.setStatusEffect(null, Status.PHASED_OUT, AvalancheDuration)
  #Call relevant rules
  async(ChaseAvalancheSpeed, AsyncBehavior.NOOP)
  async(ChaseAvalancheRadius, AsyncBehavior.NOOP)
  SetAvalancheCamera()
  #Start forcing the player forwards
  eventPlayer.startForcingThrottle(1, 1, 0, 0, 0, 0)
  #Create a bunch of effects that make up the ability
  eventPlayer.AvalancheEffects = []
  #Spheres
  createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, eventPlayer, eventPlayer.AvalancheCurrentRadius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
  eventPlayer.AvalancheEffects = eventPlayer.AvalancheEffects.concat(getLastCreatedEntity())
  createEffect(getAllPlayers(), Effect.SPHERE, eventPlayer.getTeam(), eventPlayer, eventPlayer.AvalancheCurrentRadius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
  eventPlayer.AvalancheEffects = eventPlayer.AvalancheEffects.concat(getLastCreatedEntity())
  #Sparkles
  createEffect(getAllPlayers(), Effect.SPARKLES, Color.WHITE, updateEveryTick(eventPlayer.getPosition()), eventPlayer.AvalancheCurrentRadius * 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
  eventPlayer.AvalancheEffects = eventPlayer.AvalancheEffects.concat(getLastCreatedEntity())
  createEffect(getAllPlayers(), Effect.SPARKLES, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getPosition()), eventPlayer.AvalancheCurrentRadius * 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
  eventPlayer.AvalancheEffects = eventPlayer.AvalancheEffects.concat(getLastCreatedEntity())
  #Clouds
  createEffect(getAllPlayers(), Effect.CLOUD, Color.WHITE, updateEveryTick(eventPlayer.getPosition()), eventPlayer.AvalancheCurrentRadius * 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
  eventPlayer.AvalancheEffects = eventPlayer.AvalancheEffects.concat(getLastCreatedEntity())
  createEffect(getAllPlayers(), Effect.CLOUD, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getPosition()), eventPlayer.AvalancheCurrentRadius * 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
  eventPlayer.AvalancheEffects = eventPlayer.AvalancheEffects.concat(getLastCreatedEntity())
  #Wait before clearing avalanche
  wait(AvalancheDuration, Wait.ABORT_WHEN_FALSE)
  ClearAvalanche()


def SetAvalancheCamera():
  @Name "Subroutine - Set Avalanche camera"
  
  #Force the player to third person
  eventPlayer.startCamera(raycast(eventPlayer.getEyePosition() + Vector.UP * 0.5, eventPlayer.getEyePosition() + Vector.UP * 0.5 + eventPlayer.AvalancheFacingDirection * -5, getAllPlayers(), eventPlayer, true).getHitPosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.AvalancheFacingDirection * 20, null, eventPlayer, false).getHitPosition(), 60)


def ChaseAvalancheSpeed():
  @Name "Subroutine - Chase Avalanche Speed"
  
  #Gradually increase the player speed
  for eventPlayer.AvalancheSpeed in range(100, AvalancheMaxSpeed, (AvalancheMaxSpeed - 100) / 60):
      eventPlayer.setMoveSpeed(eventPlayer.AvalancheSpeed)
      wait()


def ChaseAvalancheRadius():
  @Name "Subroutine - Chase Avalanche Radius"
  
  eventPlayer.AvalancheCurrentRadius = 0.75
  #Gradually increase the size of the snowball
  chase(eventPlayer.AvalancheCurrentRadius, AvalancheRadius, duration=AvalancheDuration / 2, ChaseReeval.DESTINATION_AND_DURATION)


def ClearAvalanche():
  @Name "Subroutine - Clear Avalanche"
  
  #Root the player while the effect is clearing
  eventPlayer.setStatusEffect(null, Status.ROOTED, 1)
  chase(eventPlayer.AvalancheCurrentRadius, 0, duration=0.75, ChaseReeval.DESTINATION_AND_DURATION)
  eventPlayer.AvalancheSpeed = 500
  eventPlayer.IsUsingAvalanche = false
  eventPlayer.AvalancheFinalPosition = eventPlayer.getPosition()
  eventPlayer.stopForcingThrottle()
  eventPlayer.setMoveSpeed(100)
  ExplodeAvalanche()
  #Destroy Effects
  for eventPlayer.AvalancheLoop in range(len(eventPlayer.AvalancheEffects)):
      destroyEffect(eventPlayer.AvalancheEffects[eventPlayer.AvalancheLoop])
  #Clear statuses
  eventPlayer.clearStatusEffect(Status.INVINCIBLE)
  eventPlayer.clearStatusEffect(Status.ROOTED)
  eventPlayer.clearStatusEffect(Status.PHASED_OUT)
  #Reset camera to normal
  eventPlayer.stopCamera()


def ExplodeAvalanche():
  @Name "Subroutine - Explode Avalanche"
  
  async(ExplodePlayersInAvalanche, AsyncBehavior.NOOP)
  #Play a bunch of effects when the ability has come to a stop
  playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
  playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, eventPlayer.AvalancheFinalPosition + Vector.UP, AvalancheRadius * 2)
  playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, eventPlayer.AvalancheFinalPosition, AvalancheRadius * 4)
  wait(0.05)
  playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, eventPlayer.getTeam(), eventPlayer.AvalancheFinalPosition + Vector.UP, AvalancheRadius * 2)
  playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.getTeam(), eventPlayer.AvalancheFinalPosition, AvalancheRadius * 4)
  wait(0.15)
  playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, eventPlayer.AvalancheFinalPosition, AvalancheRadius * 4)
  wait(0.05)
  playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.getTeam(), eventPlayer.AvalancheFinalPosition, AvalancheRadius * 4)
  wait(0.15)
  playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, eventPlayer.AvalancheFinalPosition, AvalancheRadius * 4)
  wait(0.05)
  playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, eventPlayer.getTeam(), eventPlayer.AvalancheFinalPosition, AvalancheRadius * 4)
  wait(0.25)


def ExplodePlayersInAvalanche():
  @Name "Subroutine - Explode Players in Avalanche"
  
  wait(0.25)
  #Play explosion sound at position of player
  playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
  #Communicate, for fun
  eventPlayer.communicate(Comms.SORRY)
  #Detach players
  while len(eventPlayer.PlayersInAvalanche) > 0:
      #Detach victom from snowball
      eventPlayer.PlayersInAvalanche[0].detach()
      #Teleport the player just in case they ended up in a wall
      eventPlayer.PlayersInAvalanche[0].teleport(nearestWalkablePosition(eventPlayer.PlayersInAvalanche[0].getPosition()))
      wait()
      #Damage affected players
      damage(eventPlayer.PlayersInAvalanche[0], eventPlayer, AvalancheDamageExplosion)
      #Throw players in avalanche away from Mei
      eventPlayer.PlayersInAvalanche[0].applyImpulse(Vector.UP, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
      eventPlayer.PlayersInAvalanche[0].applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.PlayersInAvalanche[0].getPosition()), 15, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
      #Clear frozen status
      eventPlayer.PlayersInAvalanche[0].clearStatusEffect(Status.FROZEN)
      wait()
      #Knock players down while in the air
      eventPlayer.PlayersInAvalanche[0].setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 2)
      eventPlayer.PlayersInAvalanche = eventPlayer.PlayersInAvalanche.exclude(eventPlayer.PlayersInAvalanche[0])
  #Clear array, just in case
  eventPlayer.PlayersInAvalanche = []


rule "Avalanche is active, set facing direction":
  @Event eachPlayer
  @Condition eventPlayer.IsUsingAvalanche == true
  
  #Force facing direction of Mei in direction Avalanche was used
  eventPlayer.setFacing(eventPlayer.AvalancheFacingDirection, Relativity.TO_WORLD)
  wait(0.016, Wait.ABORT_WHEN_FALSE)
  if RULE_CONDITION:
      goto RULE_START


rule "Avalanche is active, play sound":
  @Event eachPlayer
  @Condition eventPlayer.IsUsingAvalanche == true
  
  #Play a constant sound while snowball is rolling
  playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 50)
  playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, eventPlayer.getPosition(), eventPlayer.AvalancheCurrentRadius * 2)
  wait(0.096, Wait.ABORT_WHEN_FALSE)
  if RULE_CONDITION:
      goto RULE_START


rule "Avalanche hit a wall":
  @Event eachPlayer
  @Condition eventPlayer.IsUsingAvalanche == true
  @Condition eventPlayer.getSpeed() < 5 * (eventPlayer.AvalancheSpeed / 100)
  
  wait(0.1, Wait.ABORT_WHEN_FALSE)
  ClearAvalanche()
  eventPlayer.setFacing(eventPlayer.AvalancheFacingDirection * -1, Relativity.TO_WORLD)


rule "Enemy is inside Avalanche":
  @Event eachPlayer
  #If any player is using avalanche
  @Condition len([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.IsUsingAvalanche == true]) > 0
  #If event player is near anyone using avalanche
  @Condition any([distance(eventPlayer.getPosition(), i.getPosition()) < i.AvalancheCurrentRadius * 1.25 for i in [player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.IsUsingAvalanche]]) == true
  
  getClosestPlayer(eventPlayer.getPosition(), getOppositeTeam(eventPlayer.getTeam())).PlayersInAvalanche = getClosestPlayer(eventPlayer.getPosition(), getOppositeTeam(eventPlayer.getTeam())).PlayersInAvalanche.concat(eventPlayer)
  eventPlayer.attachTo(getClosestPlayer(eventPlayer.getPosition(), getOppositeTeam(eventPlayer.getTeam())), localVector(eventPlayer.getPosition(), getClosestPlayer(eventPlayer.getPosition(), getOppositeTeam(eventPlayer.getTeam())), Transform.ROTATION_AND_TRANSLATION))
  eventPlayer.setStatusEffect(null, Status.FROZEN, 5)


rule "Damage players inside of Avalanche":
  @Event eachPlayer
  @Condition eventPlayer.IsUsingAvalanche == true
  
  damage(eventPlayer.PlayersInAvalanche, eventPlayer, AvalancheDamagePerTick)
  wait(0.05)
  if RULE_CONDITION:
      goto RULE_START
