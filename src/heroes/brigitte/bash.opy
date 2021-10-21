#!mainFile "../../main.opy"

#!define brigDefaultBashDistance 4.52

globalvar brigBashStunDuration = createWorkshopSetting(float[0:0.75], "Brigitte", "Shield Bash Stun Duration", 0.1)
globalvar brigBashDamage = createWorkshopSetting(int[5:75], "Brigitte", "Shield Bash Damage", 50)
globalvar brigBashSpeed = createWorkshopSetting(float[0:10], "Brigitte", "Shield Bash Range", brigDefaultBashDistance) / brigDefaultBashDistance * 100

rule "[Brig] Lower shield bash stun duration and increase damage":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE
    # @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    damage(victim, attacker, brigBashDamage - eventDamage)
    waitUntil(victim.hasStatusEffect(Status.STUNNED), 0.064)
    victim.clearStatusEffect(Status.STUNNED)
    victim.setStatusEffect(eventPlayer, Status.STUNNED, brigBashStunDuration)

rule "[Brig] Increase Bash range":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition not specialAbilitiesDisabled

    eventPlayer.setMoveSpeed(brigBashSpeed)
    waitUntil(not (eventPlayer.isFiringSecondaryFire() and eventPlayer.isFiringPrimaryFire()), 2)
    eventPlayer.setMoveSpeed(100)
