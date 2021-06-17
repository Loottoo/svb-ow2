#!mainFile "../../main.opy"


globalvar hanzoReverseFalloff


subroutine HanzoReverseFalloff


rule "init":
    hanzoReverseFalloff = [createWorkshopSetting(bool, "Hanzo", "Reverse falloff on storm arrows", true, 1), createWorkshopSetting(bool, "Hanzo", "Reverse falloff on Primary Fire", true, 0)]


def InitialHanzo():
    @Name "[Sub][Hanzo] Initial - Reduce damage by 50%"
    
    eventPlayer.setDamageDealt(50)
    
def CleanupHanzo():
    @Name "[Sub][Hanzo] Cleanup - Return damage to normal"
    eventPlayer.setDamageDealt(100)

rule "[Hanzo] Double damage for non-primary fire":
    @Event playerDealtDamage
    @Condition eventPlayer.hero == Hero.HANZO
    @Condition eventAbility != null
    @Condition eventAbility != Button.PRIMARY_FIRE
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ABILITY_1
    
    damage(victim, attacker, eventDamage * 2)


rule "[Hanzo] Reverse Falloff":
    @Event playerDealtDamage
    @Condition attacker.hero == Hero.HANZO
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.ABILITY_2 or eventAbility == Button.ABILITY_1) == true
    
    #[0] = Primary Fire   [1] = Storm arrows
    if eventAbility == Button.ABILITY_1 or eventAbility == Button.ABILITY_2 and hanzoReverseFalloff[1] == true or eventAbility == Button.PRIMARY_FIRE and hanzoReverseFalloff[0] == true:
        if distance(attacker, victim) >= 20:
            damage(victim, attacker, eventDamage * 2)
        else:
            damage(victim, attacker, eventDamage * 2 * (max(0, (distance(attacker, victim) - 1) / 20)))
    else:
        damage(victim, attacker, eventDamage * 2)
