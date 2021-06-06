#!mainFile "../../main.opy"


globalvar hanzoReverseFalloff


subroutine HanzoReverseFalloff
subroutine HanzoInital


rule "init":
    hanzoReverseFalloff = [createWorkshopSetting(bool, "Hanzo", "Reverse falloff on storm arrows", true, 1), createWorkshopSetting(bool, "Hanzo", "Reverse falloff on Primary Fire", true, 0)]


rule "[Hanzo] Initial":
  @Event eachPlayer
  @Hero hanzo
  
  async(HanzoInital, AsyncBehavior.NOOP)


rule "[Hanzo]§ Initial":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.HANZO
    
    async(HanzoInital, AsyncBehavior.NOOP)


def HanzoInital():
    @Name "[Sub][Hanzo] Initial - Reduce damage by 50%"
    
    if eventPlayer.HeroActive == Hero.HANZO:
        return
    wait()
    eventPlayer.HeroActive = Hero.HANZO
    eventPlayer.setDamageDealt(50)
    #Wait for cleanup
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
    eventPlayer.setDamageDealt(100)
    #wait()
    eventPlayer.HeroActive.remove(Hero.HANZO)


rule "[Hanzo] Double damage for non-primary fire":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility != null
    @Condition eventAbility != Button.PRIMARY_FIRE
    @Condition eventAbility != Button.ABILITY_2
    
    damage(victim, attacker, eventDamage * 2)


rule "[Hanzo]§ Double damage for non-primary fire":
    @Event playerDealtDamage
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.HANZO
    @Condition eventAbility != null
    @Condition eventAbility != Button.PRIMARY_FIRE
    @Condition eventAbility != Button.ABILITY_2
    
    damage(victim, attacker, eventDamage * 2)


rule "[Hanzo] Reverse Falloff":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.ABILITY_2) == true
    
    HanzoReverseFalloff()


rule "[Hanzo]§ Reverse Falloff":
    @Event playerDealtDamage
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.HANZO
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.ABILITY_2) == true
    
    HanzoReverseFalloff()


def HanzoReverseFalloff():
    @Name "[Sub][Hanzo] Reverse falloff"
    
    #[0] = Primary Fire   [1] = Storm arrows
    if eventAbility == Button.ABILITY_2 and hanzoReverseFalloff[1] == true or eventAbility == Button.PRIMARY_FIRE and hanzoReverseFalloff[0] == true:
        if distance(attacker, victim) >= 20:
            damage(victim, attacker, eventDamage * 2)
        else:
            damage(victim, attacker, eventDamage * 2 * (max(0, (distance(attacker, victim) - 1) / 20)))
    else:
        damage(victim, attacker, eventDamage * 2)
  