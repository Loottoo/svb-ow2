#!mainFile "../main.opy"


playervar NextUltCharge


rule "[all.del] Tank Passive: Reduce Ultimate Charge":
  @Event playerDealtDamage
  @Condition attacker.getUltCharge() < 100
  @Condition eventAbility != Button.ULTIMATE
  @Condition attacker.getUltCharge() > attacker.NextUltCharge
  @Condition (victim.getCurrentHero() in getTankHeroes() or victim.getHeroOfDuplication() in getTankHeroes()) == true
  
  attacker.setUltCharge(attacker.getUltCharge() - max(1, eventDamage / 250))
  attacker.NextUltCharge = attacker.getUltCharge() + 5


rule "[all.del] Reset Tank Passive":
  @Event eachPlayer
  @Condition eventPlayer.getUltCharge() == 0
  
  eventPlayer.NextUltCharge = 5


rule "[all.del] Tank Passive: Reduced Knockback":
  @Event eachPlayer
  @Condition (eventPlayer.getCurrentHero() in getTankHeroes() or eventPlayer.getHeroOfDuplication() in getTankHeroes()) == true
  
  if eventPlayer.getCurrentHero() == Hero.REINHARDT:
      return
  eventPlayer.setKnockbackReceived(70)
  waitUntil(not eventPlayer.getCurrentHero() in getTankHeroes() and not eventPlayer.getHeroOfDuplication() in getTankHeroes(), 9999)
  eventPlayer.setKnockbackReceived(100)
