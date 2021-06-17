#!mainFile "../../main.opy"


rule "[reinhardt.del] Charge Cancelling":
  @Event eachPlayer
  @Hero reinhardt
  @Condition eventPlayer.isUsingAbility1() == true
  
  wait(1)
  waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1) or not eventPlayer.isUsingAbility1(), 99999)
  waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.ABILITY_1), 99999)
  eventPlayer.cancelPrimaryAction()


rule "[reinhardt.del] Lower Charge Cooldown":
  @Event eachPlayer
  @Hero reinhardt
  @Condition eventPlayer.isUsingAbility1() == true
  
  waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
  eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)


rule "[reinhardt.del] Detect Facing Angle":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1() == true
    
    #Code snippet provided by Lotto!
    eventPlayer.Direction = eventPlayer.getHorizontalFacingAngle()
    wait()
    if angleDifference(eventPlayer.getHorizontalFacingAngle(), eventPlayer.Direction) > 0:
        if eventPlayer.isInAir():
            eventPlayer.startAcceleration(Vector.RIGHT, 100, 3, Relativity.TO_PLAYER, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
        else:
            eventPlayer.startAcceleration(Vector.RIGHT, 500, 7, Relativity.TO_PLAYER, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
    elif angleDifference(eventPlayer.getHorizontalFacingAngle(), eventPlayer.Direction) < 0:
        if eventPlayer.isInAir():
            eventPlayer.startAcceleration(Vector.LEFT, 100, 3, Relativity.TO_PLAYER, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
        else:
            eventPlayer.startAcceleration(Vector.LEFT, 500, 7, Relativity.TO_PLAYER, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
    else:
        eventPlayer.stopAcceleration()
    if RULE_CONDITION:
        goto RULE_START
    eventPlayer.stopAcceleration()
