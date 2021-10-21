#!mainFile "../../main.opy"

globalvar bapLampCastTime = createWorkshopSetting(float[0.75:3], "Baptiste", "Immortality Field cast time", 1.5, 0) - 0.5

def SlowdownBaptiste():
  @Name "[baptiste.del] Subroutine: Slowdown"

  eventPlayer.frac = 1
  chase(eventPlayer.frac, 0.25, duration=1, ChaseReeval.DESTINATION_AND_DURATION)
  while eventPlayer.frac > 0.25:
      eventPlayer.AddSpeedMod -= 100/62.5
      wait()
  stopChasingVariable(eventPlayer.frac)


def ReturnBaptisteToNormalSpeed():
  @Name "[baptiste.del] Subroutine: Transition to Normal Speed"

  eventPlayer.frac_0 = 0.25
  chase(eventPlayer.frac_0, 1, duration=1, ChaseReeval.DESTINATION_AND_DURATION)
  while eventPlayer.frac_0 < 1:
      eventPlayer.AddSpeedMod += 100/62.5
      wait()
  stopChasingVariable(eventPlayer.frac_0)



rule "[baptiste.del] Cast IF":
  @Event eachPlayer
  @Hero baptiste
  @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
  @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
  @Condition not specialAbilitiesDisabled(eventPlayer)

  for eventPlayer.Index in range(5):
      createEffect(getAllPlayers(), Effect.HEAL_TARGET, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getEyePosition()), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
      eventPlayer.HeroEffects.append(getLastCreatedEntity())
  createEffect(eventPlayer, Effect.GOOD_AURA_SOUND, eventPlayer.getTeam(), eventPlayer, 700, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
  eventPlayer.HeroEffects.append(getLastCreatedEntity())
  async(SlowdownBaptiste, AsyncBehavior.NOOP)
  eventPlayer.communicate(Comms.WITH_YOU)
  waitUntil(
    specialAbilitiesDisabled(eventPlayer),
    bapLampCastTime
  )
  eventPlayer.allowButton(Button.ABILITY_2)
  eventPlayer.forceButtonPress(Button.ABILITY_2)
  eventPlayer.disallowButton(Button.ABILITY_2)
  CleanupEffects()
  async(ReturnBaptisteToNormalSpeed, AsyncBehavior.NOOP)
  waitUntil(not eventPlayer.isUsingAbility2(), 0.5)
  eventPlayer.setAbilityCooldown(Button.ABILITY_2, 25)
