#!mainFile "../../main.opy"

globalvar ZenShieldHealth = createWorkshopSetting(int[0:100], "Zenyatta", "Secondary Fire Shield Health (Setting to less than 10 disables shield)", 50, 1)
globalvar ZenShieldCooldown = createWorkshopSetting(float[2:20], "Zenyatta", "Secondary Fire Shield Cooldown on Break", 4, 0)
globalvar ZenShieldRechargeRate = createWorkshopSetting(int[0:100], "Zenyatta", "Shield Recharge Rate", 25, 2)

playervar ZenShield
playervar ZenShieldCurrentHealth


/*
ZenShield is one variable.

Index 0 is the Health Pool.
Index 1 is for the shield health at time of deployment
Index 2 is the shield visuals.
*/
#!defineMember zenShieldHealthPool ZenShield[0]
#!defineMember zenShieldStartingHp ZenShield[1]
#!defineMember zenShieldEffects ZenShield[2]

/*
Indices indicate slot of enemy player.

zenAttackerRunCounter is a counter that ticks up on real instances of damage and down on the corresponding compensation damage.
zenAttackerIsCompRun notes whether or not comp damage is currently being processed.
*/
playervar zenAttackerRunCounter
playervar zenAttackerIsCompRun

#!define zenShieldAngleOfProtection 40
#!define didZenShieldBlock(incomingDir) (angleBetweenVectors(eventPlayer.getFacingDirection(), (incomingDir) * -1) < zenShieldAngleOfProtection)

#!define zenUnblockableNoShieldDamageAttacks(attacker, ability) (\
 (attacker).getCurrentHero() == Hero.SIGMA and (ability) == Button.ULTIMATE\
 or (attacker).getCurrentHero() == Hero.TORBJORN and (ability) == Button.ULTIMATE\
 or (attacker).getCurrentHero() == Hero.WIDOWMAKER and (ability) == Button.ABILITY_2\
 or (attacker).getCurrentHero() == Hero.HANZO and (ability) == Button.ULTIMATE\
)

#!define zenUnblockableDoesShieldDamageAttacks(attacker, ability) (\
 eventAbility == Button.MELEE\
 or ((attacker).getCurrentHero() == Hero.GENJI and ((ability) == Button.ULTIMATE or (ability) == Button.ABILITY_1))\
 or (attacker).getCurrentHero() == Hero.REINHARDT\
 or (attacker).getCurrentHero() == Hero.DVA and (ability) == Button.ABILITY_1\
 or (attacker).getCurrentHero() == Hero.WINSTON\
 or (attacker).getCurrentHero() == Hero.HAMMOND and (ability) == Button.SECONDARY_FIRE\
 or (attacker).getCurrentHero() == Hero.DOOMFIST and (ability) != Button.PRIMARY_FIRE and (ability) != Button.ULTIMATE\
 or (attacker).getCurrentHero() == Hero.JUNKRAT and (ability) == Button.ABILITY_2\
 or (attacker).getCurrentHero() == Hero.BRIGITTE and (ability) == Button.PRIMARY_FIRE\
 or (attacker).getCurrentHero() == Hero.MOIRA and (ability) == Button.ULTIMATE\
)

#!define zenUnblockableKnockbacks(attacker, ability) (\
 (ability) == Button.MELEE\
 or (attacker).getCurrentHero() == Hero.REINHARDT\
 or (attacker).getCurrentHero() == Hero.DVA and (ability) == Button.ABILITY_1\
 or (attacker).getCurrentHero() == Hero.HAMMOND and (ability) == Button.SECONDARY_FIRE\
 or (attacker).getCurrentHero() == Hero.DOOMFIST and (ability) != Button.PRIMARY_FIRE and (ability) != Button.ULTIMATE\
 or (attacker).getCurrentHero() == Hero.SIGMA and (ability) == Button.ULTIMATE\
)

rule "Global Zenyatta Create Workshop Variable and GUI":
    createProgressBarInWorldText([i for i in localPlayer if localPlayer.hero == Hero.ZENYATTA and (not (localPlayer.isDead() or localPlayer.isUsingUltimate() or localPlayer.isCommunicatingEmote()))], localPlayer.ZenShieldCurrentHealth / ZenShieldHealth * 100, "Shield HP: {0}".format(ceil(localPlayer.ZenShieldCurrentHealth)), updateEveryTick(localPlayer.getEyePosition() + localPlayer.getFacingDirection() * 30 + crossProduct(crossProduct(localPlayer.getFacingDirection(), Vector.UP), localPlayer.getFacingDirection()) * -8), 0.7, Clip.NONE, Color.SKY_BLUE, Color.WHITE, ProgressWorldTextReeval.VISIBILITY_POSITION_VALUES_AND_COLOR, SpecVisibility.DEFAULT)


rule "Zenyatta hero picked (no complications with swapping, don't worry)":
    @Event eachPlayer

    eventPlayer.ZenShieldCurrentHealth = ZenShieldHealth

rule "Track when people deal damage to Zen while he is shielding":
    @Event playerDealtDamage
    @Condition victim.hero == Hero.ZENYATTA
    # Is Zen shielding?
    @Condition victim.zenShieldHealthPool == true
    # If we were mid-adding real damage
    @Condition victim.zenAttackerRunCounter[attacker.getSlot()] > 0
    @Condition not victim.zenAttackerIsCompRun[attacker.getSlot()]

    victim.zenAttackerIsCompRun[attacker.getSlot()] = true


rule "Zenyatta Shield Damage":
    @Event playerTookDamage
    @Hero zenyatta
    @Condition eventPlayer.zenShieldHealthPool == true

    # This was an EMP damage event. Kill the shield and do nothing else.
    if attacker.getCurrentHero() == Hero.SOMBRA and eventAbility == null:
        eventPlayer.ZenShieldCurrentHealth = 0
    # This is compensation damage
    if eventPlayer.zenAttackerIsCompRun[attacker.getSlot()]:
        eventPlayer.zenAttackerRunCounter[attacker.getSlot()] -= 1
        if eventPlayer.zenAttackerRunCounter[attacker.getSlot()] == 0:
            eventPlayer.zenAttackerIsCompRun[attacker.getSlot()] = false
        return
    # If we got this far, this is a normal damage instance to consider
    if didZenShieldBlock(eventDirection) and not zenUnblockableNoShieldDamageAttacks(attacker, eventAbility) and not zenUnblockableDoesShieldDamageAttacks(attacker, eventAbility):
        # Cancel Roadhog hook ( shields block hooks :) )
        if attacker.getCurrentHero() == Hero.ROADHOG and eventAbility == Button.ABILITY_1:
            if not attacker.isUsingUltimate():
                attacker.cancelPrimaryAction()

        # If the damage overwhelmed the shield, break the shield and ensure the shield blocked the remaining damage (ala real OW shields)
        if eventDamage > eventPlayer.ZenShieldCurrentHealth / eventPlayer.zenShieldStartingHp:
            # Don't heal Sombra EMP damage
            if not (attacker.getCurrentHero() == Hero.SOMBRA and eventAbility == null):
                heal(eventPlayer, null, eventDamage - eventPlayer.ZenShieldCurrentHealth / eventPlayer.zenShieldStartingHp)
            eventPlayer.ZenShieldCurrentHealth = 0
        # Otherwise, deduct the proper amount of damage from Zen's shield
        else:
            eventPlayer.ZenShieldCurrentHealth = max(0, eventPlayer.ZenShieldCurrentHealth - (((eventDamage * 0.4 if attacker.getCurrentHero() == Hero.WIDOWMAKER and eventAbility == Button.PRIMARY_FIRE and attacker.isFiringSecondaryFire() else eventDamage * 0.5) if eventWasCriticalHit else eventDamage) * eventPlayer.zenShieldStartingHp))
    # The shield didn't block the attack, either because it was unblockable or because the shield wasn't in the way.
    # We now need to deal damage to Zenyatta to make it appear as if he took normal damage
    else:
        # If the attack is supposed to deal damage to the shield as well as the holder (Reinhardt hammer, Winston Tesla cannon, etc.), deal damage to the shield
        if zenUnblockableDoesShieldDamageAttacks(attacker, eventAbility):
            eventPlayer.ZenShieldCurrentHealth = max(0, eventPlayer.zenShieldStartingHp - (((eventDamage * 0.4 if attacker.getCurrentHero() == Hero.WIDOWMAKER and eventAbility == Button.PRIMARY_FIRE and attacker.isFiringSecondaryFire() else eventDamage * 0.5) if eventWasCriticalHit else eventDamage) * eventPlayer.zenShieldStartingHp))
        # Damage the player
        damage(eventPlayer, attacker, (eventDamage * (eventPlayer.zenShieldStartingHp - 1)) * eventPlayer.zenShieldStartingHp)
        # Tell system we queued up some compensation damage
        eventPlayer.zenAttackerRunCounter[attacker.getSlot()] += 1


rule "Zenyatta Knockback Blocked By Shield":
    @Event playerReceivedKnockback
    @Hero zenyatta
    @Condition eventPlayer.zenShieldHealthPool == true
    @Condition eventAbility != Button.MELEE
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), eventDirection * -1) < zenShieldAngleOfProtection
    @Condition not zenUnblockableKnockbacks(attacker, eventAbility)

    wait()
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "Zenyatta Secondary Creates Shield":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.ZenShieldCurrentHealth >= 10
    @Condition eventPlayer.isFiringSecondaryFire() == true

    stopChasingVariable(eventPlayer.ZenShieldCurrentHealth)

    createEffect(getAllPlayers().exclude(eventPlayer), Effect.GOOD_AURA, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 0.5 + crossProduct(crossProduct(eventPlayer.getFacingDirection(), Vector.UP), eventPlayer.getFacingDirection()) * -0.25), 0.38, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.zenShieldEffects = [getLastCreatedEntity()]
    createEffect(eventPlayer, Effect.GOOD_AURA, Color.SKY_BLUE, updateEveryTick(eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 0.5 + crossProduct(crossProduct(eventPlayer.getFacingDirection(), Vector.UP), eventPlayer.getFacingDirection()) * -0.215), 0.475, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    eventPlayer.zenShieldEffects.append(getLastCreatedEntity())

    eventPlayer.setDamageReceived(100 / eventPlayer.ZenShieldCurrentHealth)
    eventPlayer.addHealthPool(Health.SHIELDS, 1, false, false)
    eventPlayer.zenShieldHealthPool = getLastCreatedHealthPool()
    eventPlayer.zenShieldStartingHp = eventPlayer.ZenShieldCurrentHealth
    waitUntil(not eventPlayer.isFiringSecondaryFire() or not eventPlayer.ZenShieldCurrentHealth, 99999)
    removeHealthPool(eventPlayer.zenShieldHealthPool)
    eventPlayer.zenShieldHealthPool = null
    eventPlayer.zenShieldStartingHp = 0
    eventPlayer.setDamageReceived(100)
    destroyEffect(eventPlayer.zenShieldEffects)
    eventPlayer.zenShieldEffects = []
    if eventPlayer.isFiringSecondaryFire():
        playEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())).concat(eventPlayer), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 95)
        wait(1.6)
        chase(eventPlayer.ZenShieldCurrentHealth, ZenShieldHealth, rate=25, ChaseReeval.NONE)
        wait(ZenShieldCooldown - 1.6)
    else:
        wait(1.6, Wait.RESTART_WHEN_TRUE)
        chase(eventPlayer.ZenShieldCurrentHealth, ZenShieldHealth, rate=ZenShieldRechargeRate, ChaseReeval.NONE)


