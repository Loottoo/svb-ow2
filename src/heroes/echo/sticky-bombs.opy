#!mainFile "../../main.opy"

globalvar echoStickyBombCount = createWorkshopSetting(int[1:6], "Echo", "Number of sticky bombs to fire", 5, 0)

rule "Cancel Sticky Bombs early so only 5 spawn instead of 6":
  @Event eachPlayer
  @Condition eventPlayer.hero == Hero.ECHO
  @Condition eventPlayer.isFiringSecondaryFire() == true

  wait(0.06 * echoStickyBombCount, Wait.ABORT_WHEN_FALSE)
  # We record the player's current velocity and apply an impulse after the status, this ensures that the momentum is maintained.
  eventPlayer.Index = eventPlayer.getVelocity()
  eventPlayer.setStatusEffect(null, Status.STUNNED, 0.016)
  eventPlayer.applyImpulse(eventPlayer.Index, eventPlayer.getHorizontalSpeed(), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
