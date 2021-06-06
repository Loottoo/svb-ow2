#!mainFile "../../main.opy"

subroutine RoadhogInitial

def RoadhogInitial():
  @Name "[Sub][Roadhog] Initial - Knockback dealt 80%"
  
  if eventPlayer.HeroActive == Hero.ROADHOG:
      return
  wait()
  eventPlayer.HeroActive = Hero.ROADHOG
  eventPlayer.setKnockbackDealt(80)
  #Wait for cleanup
  waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
  eventPlayer.setKnockbackDealt(100)
  #wait()
  eventPlayer.HeroActive.remove(Hero.ROADHOG)

rule "[Roadhog] Initial":
  @Event eachPlayer
  @Hero roadhog
  
  async(RoadhogInitial, AsyncBehavior.NOOP)


rule "[Roadhog]§ Initial":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.ROADHOG
  
  async(RoadhogInitial, AsyncBehavior.NOOP)
