#!mainFile "../../main.opy"


def SlowdownBaptiste():
  @Name "[baptiste.del] Subroutine: Slowdown"
  
  _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.BaptisteMoveSpeedID])[0]] = 100
  eventPlayer.frac = 1
  chase(eventPlayer.frac, 0.25, duration=1, ChaseReeval.DESTINATION_AND_DURATION)
  while eventPlayer.frac > 0.25:
      if not (eventPlayer.getCurrentHero() == Hero.BAPTISTE or eventPlayer.getHeroOfDuplication() == Hero.BAPTISTE):
          break
      _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.BaptisteMoveSpeedID])[0]] = (4 * eventPlayer.frac * eventPlayer.frac * eventPlayer.frac if eventPlayer.frac < 0.5 else 1 - ((((-2 * eventPlayer.frac + 2) * (-2 * eventPlayer.frac + 2)) * (-2 * eventPlayer.frac + 2)) / 2)) * 100
      eventPlayer.setMoveSpeed((4 * eventPlayer.frac * eventPlayer.frac * eventPlayer.frac if eventPlayer.frac < 0.5 else 1 - ((((-2 * eventPlayer.frac + 2) * (-2 * eventPlayer.frac + 2)) * (-2 * eventPlayer.frac + 2)) / 2)) * 100)
      wait()
  _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.BaptisteMoveSpeedID])[0]] = 100
  stopChasingVariable(eventPlayer.frac)


def ReturnBaptisteToNormalSpeed():
  @Name "[baptiste.del] Subroutine: Transition to Normal Speed"
  
  _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.BaptisteMoveSpeedID])[0]] = 0
  eventPlayer.frac_0 = 0.25
  chase(eventPlayer.frac_0, 1, duration=1, ChaseReeval.DESTINATION_AND_DURATION)
  while eventPlayer.frac_0 < 1:
      if not (eventPlayer.getCurrentHero() == Hero.BAPTISTE or eventPlayer.getHeroOfDuplication() == Hero.BAPTISTE):
          break
      _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.BaptisteMoveSpeedID])[0]] = (4 * eventPlayer.frac_0 * eventPlayer.frac_0 * eventPlayer.frac_0 if eventPlayer.frac_0 < 0.5 else 1 - ((((-2 * eventPlayer.frac_0 + 2) * (-2 * eventPlayer.frac_0 + 2)) * (-2 * eventPlayer.frac_0 + 2)) / 2)) * 100
      eventPlayer.setMoveSpeed((4 * eventPlayer.frac_0 * eventPlayer.frac_0 * eventPlayer.frac_0 if eventPlayer.frac_0 < 0.5 else 1 - ((((-2 * eventPlayer.frac_0 + 2) * (-2 * eventPlayer.frac_0 + 2)) * (-2 * eventPlayer.frac_0 + 2)) / 2)) * 100)
      wait()
  _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.BaptisteMoveSpeedID])[0]] = 100
  stopChasingVariable(eventPlayer.frac_0)


def BaptisteCastIF():
  @Name "[baptiste.del] Subroutine: Cast Immortality Field"
  
  if eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0:
      return
  if eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.STUNNED) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.isDead():
      return
  for eventPlayer.repeat in range(5):
      createEffect(getAllPlayers(), Effect.HEAL_TARGET, eventPlayer.getTeam(), updateEveryTick(eventPlayer.getEyePosition()), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
      eventPlayer.HeroEffects.append(getLastCreatedEntity())
  createEffect(eventPlayer, Effect.GOOD_AURA_SOUND, eventPlayer.getTeam(), eventPlayer, 700, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
  eventPlayer.HeroEffects.append(getLastCreatedEntity())
  async(SlowdownBaptiste, AsyncBehavior.NOOP)
  eventPlayer.communicate(Comms.WITH_YOU)
  waitUntil(
    any(
      [i == true for i in [eventPlayer.hasStatusEffect(Status.ASLEEP),
      eventPlayer.hasStatusEffect(Status.HACKED), eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN),
      eventPlayer.hasStatusEffect(Status.STUNNED), eventPlayer.hasStatusEffect(Status.FROZEN)]]
    ),
    createWorkshopSetting(float[0.75:3], "Baptiste", "Immortality Field cast time", 1.5, 0) - 0.5
  )
  #Stun check
  if any([i == false for i in [eventPlayer.hasStatusEffect(Status.ASLEEP), eventPlayer.hasStatusEffect(Status.HACKED), eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN), eventPlayer.hasStatusEffect(Status.STUNNED), eventPlayer.hasStatusEffect(Status.FROZEN)]]):
      eventPlayer.allowButton(Button.ABILITY_2)
      eventPlayer.forceButtonPress(Button.ABILITY_2)
      eventPlayer.disallowButton(Button.ABILITY_2)
  CleanupEffects()
  async(ReturnBaptisteToNormalSpeed, AsyncBehavior.NOOP)
  waitUntil(not eventPlayer.isUsingAbility2(), 0.5)
  eventPlayer.setAbilityCooldown(Button.ABILITY_2, 25)


rule "[baptiste.del] Cast IF":
  @Event eachPlayer
  @Hero baptiste
  @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
  
  BaptisteCastIF()


rule "[baptiste.del] Cast IF (Duplication)":
  @Event eachPlayer
  @Hero echo
  @Condition eventPlayer.getHeroOfDuplication() == Hero.BAPTISTE
  @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
  
  BaptisteCastIF()
