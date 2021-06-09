#!mainFile "../../main.opy"


rule "[McCree] Replace stun with rooted status":
  @Event playerDealtDamage
  @Hero mccree
  @Condition eventAbility == Button.ABILITY_2
  
  wait()
  victim.clearStatusEffect(Status.STUNNED)
  victim.setStatusEffect(attacker, Status.ROOTED, 0.8)


rule "[McCree]ยง Replace stun with rooted status":
  @Event playerDealtDamage
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.MCCREE
  @Condition eventAbility == Button.ABILITY_2
  
  wait()
  victim.clearStatusEffect(Status.STUNNED)
  victim.setStatusEffect(attacker, Status.ROOTED, 0.8)
