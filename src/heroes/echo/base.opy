#!mainFile "../../main.opy"


rule "[echo.del] Max Health Fix":
  @Event eachPlayer
  @Hero echo
  
  #Some heroes change their max health and add health pools, there is currently a bug where normal health pools get affected, so this attempts to fix that.
  if eventPlayer.isDuplicatingAHero():
      return
  if not eventPlayer.isDead():
    eventPlayer.resurrect()
    
  wait()
  eventPlayer.setMaxHealth(0)
  wait()
  eventPlayer.setMaxHealth(100)
  wait()
  heal(eventPlayer, null, max(100, eventPlayer.EchoLastHealth) - eventPlayer.getHealth())
