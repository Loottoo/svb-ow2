#!mainFile "../../main.opy"

def InitialEcho():
  @Name "[Sub] Initial Echo"
  waitUntil(eventPlayer.hero != Hero.ECHO, 0.112)
  waitUntil(eventPlayer.hero != Hero.ECHO, 0.112)
  waitUntil(eventPlayer.hero != Hero.ECHO, 0.112)
  waitUntil(eventPlayer.hero != Hero.ECHO, 0.298)
  if eventPlayer.hero == Hero.ECHO:
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setMeleeEnabled(true)
    CleanSlate()


#rule "[echo.del] Max Health Fix":
#  @Event eachPlayer
#  @Hero echo
#  
#  #Some heroes change their max health and add health pools, there is currently a bug where normal health pools get affected, so this attempts to fix that.
#  if eventPlayer.isDuplicatingAHero():
#      return
#  if not eventPlayer.isDead():
#    eventPlayer.resurrect()
#    
#  wait()
#  eventPlayer.setMaxHealth(0)
#  wait()
#  eventPlayer.setMaxHealth(100)
#  wait()
#  heal(eventPlayer, null, max(100, eventPlayer.EchoLastHealth) - eventPlayer.getHealth())
