#!mainFile "../../main.opy"


def ReinhardtChargeCancelling():
  @Name "[reinhardt.del] Subroutine: Charge Cancelling"
  
  wait(1)
  waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1) or not eventPlayer.isUsingAbility1(), 99999)
  waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.ABILITY_1), 99999)
  eventPlayer.cancelPrimaryAction()


rule "[reinhardt.del] Charge Cancelling":
  @Event eachPlayer
  @Hero reinhardt
  @Condition eventPlayer.isUsingAbility1() == true
  
  ReinhardtChargeCancelling()


def ReinhardtLowerChargeCooldown():
  @Name "[reinhardt.del] Subroutine: Lower Charge Cooldown"
  
  waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
  eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)


rule "[reinhardt.del] Lower Charge Cooldown":
  @Event eachPlayer
  @Hero reinhardt
  @Condition eventPlayer.isUsingAbility1() == true
  
  ReinhardtLowerChargeCooldown()


def ReinhardtDetectFacingAngle():
    @Name "[reinhardt.del] Subroutine: Detect Facing Angle"
    
    #Code snippet provided by Lotto!
    eventPlayer.facingAngle = eventPlayer.getHorizontalFacingAngle()
    wait()
    if angleDifference(eventPlayer.getHorizontalFacingAngle(), eventPlayer.facingAngle) > 0:
        if eventPlayer.isInAir():
            eventPlayer.startAcceleration(Vector.RIGHT, 100, 3, Relativity.TO_PLAYER, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
        else:
            eventPlayer.startAcceleration(Vector.RIGHT, 500, 7, Relativity.TO_PLAYER, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
    elif angleDifference(eventPlayer.getHorizontalFacingAngle(), eventPlayer.facingAngle) < 0:
        if eventPlayer.isInAir():
            eventPlayer.startAcceleration(Vector.LEFT, 100, 3, Relativity.TO_PLAYER, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
        else:
            eventPlayer.startAcceleration(Vector.LEFT, 500, 7, Relativity.TO_PLAYER, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
    else:
        eventPlayer.stopAcceleration()
    if RULE_CONDITION:
        goto RULE_START
    eventPlayer.stopAcceleration()


rule "[reinhardt.del] Detect Facing Angle":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1() == true
    
    ReinhardtDetectFacingAngle()


rule "[reinhardt.del] Initial (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
    
    InitialReinhardt()


rule "[reinhardt.del] Charge Cancelling (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility1() == true
    
    ReinhardtChargeCancelling()


rule "[reinhardt.del] Lower Charge Cooldown (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility1() == true
    
    ReinhardtLowerChargeCooldown()


rule "[reinhardt.del] Detect Facing Angle (Duplication)":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility1() == true
    
    ReinhardtDetectFacingAngle()
