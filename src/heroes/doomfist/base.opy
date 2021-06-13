#!mainFile "../../main.opy"


playervar PunchDamages
playervar PunchCharge
playervar DFDidHitPlayer
playervar DFPunchCharge
playervar Punching


rule "Doomfist Init":
    @Event eachPlayer
    @Condition eventPlayer.hero == Hero.DOOMFIST

    eventPlayer.Punching = false

rule "Rocket Punch and Meteor Strike Damage, Plus Vertical Punch Damage Checks":
    @Event playerDealtDamage
    @Condition attacker.hero == Hero.DOOMFIST
    
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
