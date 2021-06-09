#!mainFile "../../main.opy"

rule "Cancel Sticky Bombs early so only 5 spawn instead of 6":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.isFiringSecondaryFire() == true
  
  wait(0.06 * createWorkshopSetting(int[1:6], "Echo", "Number of sticky bombs to fire", 5, 0), Wait.ABORT_WHEN_FALSE)
  eventPlayer.cancelPrimaryAction()
