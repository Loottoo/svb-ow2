#!mainFile "../../main.opy"


rule "[McCree] Replace stun with rooted status":
  @Event playerDealtDamage
  @Condition attacker.hero == Hero.MCCREE
  @Condition eventAbility == Button.ABILITY_2
  
  wait()
  victim.clearStatusEffect(Status.STUNNED)
  victim.setStatusEffect(attacker, Status.ROOTED, 0.8)
