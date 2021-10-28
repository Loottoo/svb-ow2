#!mainFile "../../main.opy"

#!define brigDefaultBashDistance 4.52
#!define brigDefaultBashDamage 5

globalvar brigBashStunDuration = createWorkshopSetting(float[0:0.75], "Brigitte", "Shield Bash Stun Duration", 0.1)
globalvar brigBashDamage = createWorkshopSetting(int[brigDefaultBashDamage:75], "Brigitte", "Shield Bash Damage", 50)
globalvar brigBashSpeed = createWorkshopSetting(float[0:10], "Brigitte", "Shield Bash Range", 9) / brigDefaultBashDistance * 100

rule "[Brig] Lower shield bash stun duration and increase damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero == Hero.BRIGITTE
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isFiringSecondaryFire()

    damage(victim, attacker, brigBashDamage - brigDefaultBashDamage)
    waitUntil(victim.hasStatusEffect(Status.STUNNED), 0.064)
    victim.clearStatusEffect(Status.STUNNED)
    victim.setStatusEffect(eventPlayer, Status.STUNNED, brigBashStunDuration)

rule "[Brig] Increase Bash range":
    @Event eachPlayer
    @Condition eventPlayer.hero == Hero.BRIGITTE
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setMoveSpeed(brigBashSpeed)
    waitUntil(not (eventPlayer.isFiringSecondaryFire() and eventPlayer.isFiringPrimaryFire()), 2)
    eventPlayer.setMoveSpeed(100)
