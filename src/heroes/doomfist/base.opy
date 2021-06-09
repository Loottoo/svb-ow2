#!mainFile "../../main.opy"


playervar PunchDamages
playervar PunchCharge
playervar DFDidHitPlayer
playervar DFPunchCharge
playervar Punching


rule "Doomfist uninit":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.DOOMFIST

    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setMeleeEnabled(true)


rule "Doomfist Init":
    @Event eachPlayer
    @Hero doomfist

    eventPlayer.setDamageDealt(100)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.Punching = false


rule "Doomfist uninit - ECHO":
    @Event eachPlayer
    @Condition eventPlayer.getHeroOfDuplication() != Hero.DOOMFIST
    
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setMeleeEnabled(true)


rule "Doomfist Init - ECHO":
    @Event eachPlayer
    @Hero echo
    #@Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DOOMFIST
    
    eventPlayer.setDamageDealt(100)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.Punching = false


rule "Rocket Punch and Meteor Strike Damage, Plus Vertical Punch Damage Checks":
    @Event playerDealtDamage
    @Hero doomfist
    
    if eventAbility == Button.SECONDARY_FIRE:
        eventPlayer.PunchDamages += 1
        damage(victim, eventPlayer, eventPlayer.PunchCharge * 30 * 5)
        if eventPlayer.PunchDamages == 2:
            damage(victim, eventPlayer, 40 * 5)
        else:
            if eventWasEnvironment:
                eventPlayer.DFDidHitPlayer = false
            else:
                #Stops Doomfist
                eventPlayer.applyImpulse(vect(eventPlayer.getFacingDirection().x * -1, eventPlayer.getFacingDirection().y * -1, eventPlayer.getFacingDirection().z * -1), 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
                eventPlayer.DFDidHitPlayer = true
            #Knocks opponent back based on how they got punched
            victim.applyImpulse(eventPlayer.getFacingDirection(), eventPlayer.DFPunchCharge, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    elif eventAbility == Button.ULTIMATE:
        if distance(eventPlayer.getPosition(), victim.getPosition()) > 2.2:
            damage(victim, eventPlayer, eventDamage * 0.25)


rule "Rocket Punch and Meteor Strike Damage, Plus Vertical Punch Damage Checks - ECHO":
    @Event playerDealtDamage
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DOOMFIST
    
    if eventAbility == Button.SECONDARY_FIRE:
        eventPlayer.PunchDamages += 1
        damage(victim, eventPlayer, eventPlayer.PunchCharge * 30 * 5)
        if eventPlayer.PunchDamages == 2:
            damage(victim, eventPlayer, 40 * 5)
        else:
            if eventWasEnvironment:
                eventPlayer.DFDidHitPlayer = false
            else:
                #Stops Doomfist
                eventPlayer.applyImpulse(vect(eventPlayer.getFacingDirection().x * -1, eventPlayer.getFacingDirection().y * -1, eventPlayer.getFacingDirection().z * -1), 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
                eventPlayer.DFDidHitPlayer = true
            #Knocks opponent back based on how they got punched
            victim.applyImpulse(eventPlayer.getFacingDirection(), eventPlayer.DFPunchCharge, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    elif eventAbility == Button.ULTIMATE:
        if distance(eventPlayer.getPosition(), victim.getPosition()) > 2.2:
            damage(victim, eventPlayer, eventDamage * 0.25)
