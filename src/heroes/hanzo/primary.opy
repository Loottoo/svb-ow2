#!mainFile "../../main.opy"


globalvar hanzoReverseFalloff


subroutine HanzoReverseFalloff
subroutine HanzoInitial


rule "init":
    hanzoReverseFalloff = [createWorkshopSetting(bool, "Hanzo", "Reverse falloff on storm arrows", true, 1), createWorkshopSetting(bool, "Hanzo", "Reverse falloff on Primary Fire", true, 0)]


rule "[Hanzo] Initial":
  @Event eachPlayer
  @Hero hanzo
  
  async(HanzoInitial, AsyncBehavior.NOOP)


rule "[Hanzo]§ Initial":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.HANZO
    
    async(HanzoInitial, AsyncBehavior.NOOP)


def HanzoInitial():
    @Name "[Sub][Hanzo] Initial - Reduce damage by 50%"
    
    waitUntil(eventPlayer.HeroActive == null, 9999)
    if eventPlayer.HeroActive == Hero.HANZO:
        return
    wait()
    eventPlayer.setDamageDealt(50)
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    eventPlayer.setDamageDealt(100)
    eventPlayer.HeroActive = null


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
