#!mainFile "../../main.opy"

globalvar brigBashStunDuration = createWorkshopSetting(float[0:0.75], "Brigitte", "Shield Bash Stun Duration", 0.1)
globalvar brigBashDamage = createWorkshopSetting(int[5:75], "Brigitte", "Shield Bash Damage", 40)

rule "[Brig] Lower shield bash stun duration and increase damage":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    damage(victim, attacker, brigBashDamage - eventDamage)
    waitUntil(victim.hasStatusEffect(Status.STUNNED), 0.064)
    victim.clearStatusEffect(Status.STUNNED)
    victim.setStatusEffect(eventPlayer, Status.STUNNED, brigBashStunDuration)
