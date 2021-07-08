#!mainFile "../../main.opy"


rule "Doomfist Vertical Rocket Punch":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.DFPunchCharge = 3.5
    chase(eventPlayer.DFPunchCharge, 6, duration=1.4, ChaseReeval.DESTINATION_AND_DURATION)
    #Punch starts
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 99999)
    stopChasingVariable(eventPlayer.DFPunchCharge)
    #Player cancels Rocket Punch, gets CC'd or hacked; Stop execution
    if eventPlayer.hasStatusEffect(Status.STUNNED) or eventPlayer.hasStatusEffect(Status.ROOTED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        return
    eventPlayer.HeroAbsoluteSpeedMod = 0
    if not eventPlayer.DFDidHitPlayer:
        #If Doomfist is punching upwards, impulse in the direction until he gets off the ground
        if eventPlayer.getFacingDirection().y > 0.05:
            while eventPlayer.isOnGround() and eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0:
                eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 30, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
                wait(0.05)
        eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 50, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.08)
    eventPlayer.HeroAbsoluteSpeedMod = 100
    eventPlayer.DFDidHitPlayer = false

rule "Rocket Punch":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setDamageDealt(20)
    eventPlayer.Punching = true
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.PunchDamages = 0
    eventPlayer.PunchCharge = -0.14
    chase(eventPlayer.PunchCharge, 1, rate=1, ChaseReeval.NONE)
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 3.97, 2.5)
    stopChasingVariable(eventPlayer.PunchCharge)
    eventPlayer.PunchCharge = max(0, eventPlayer.PunchCharge)
    #smallMessage(eventPlayer, "Punch Charge: {0}".format(eventPlayer.PunchCharge))
    waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 3.87, 1.5)
    wait(0.05)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.Punching = false
