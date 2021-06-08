#!mainFile "../../main.opy"


def CleanupZarya():
  @Name "[zarya.del] Subroutine: Cleanup"
  
  waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()), 9999)
  CleanupTexts()
  eventPlayer.setAbility1Enabled(true)
  eventPlayer.setAbility2Enabled(true)
  stopChasingVariable(eventPlayer.ZaryaBubbleCooldown)
  wait()
  eventPlayer.HeroActive = null


def InitialZarya():
  @Name "[zarya.del] Subroutine: Initial"
  
  waitUntil(eventPlayer.HeroActive == null, 9999)
  if eventPlayer.HeroActive == Hero.ZARYA:
      return
  wait()
  eventPlayer.HeroActive = Hero.ZARYA
  wait()
  #Variable setup
  eventPlayer.ZaryaBubbleCharges = 2
  eventPlayer.ZaryaBubbleCooldown = 5
  chase(eventPlayer.ZaryaBubbleCooldown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
  createInWorldText(null if eventPlayer.isCommunicatingEmote() or eventPlayer.isDead() else eventPlayer, "({0}) [{1}]".format(floor(eventPlayer.ZaryaBubbleCharges) if floor(eventPlayer.ZaryaBubbleCharges) > 0 else iconString(Icon.CROSS), iconString(Icon.CHECKMARK) if floor(eventPlayer.ZaryaBubbleCharges) == 2 else ceil(eventPlayer.ZaryaBubbleCooldown)), updateEveryTick(localPlayer.getEyePosition() + (100 * (2.27 * (crossProduct(localPlayer.getFacingDirection(), angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + ((-1.37 - 0.2) * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 1.3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
  eventPlayer.HeroTexts.append(getLastCreatedText())
  createInWorldText(null if eventPlayer.isCommunicatingEmote() or eventPlayer.isDead() else eventPlayer, "({0}) [{1}]".format(floor(eventPlayer.ZaryaBubbleCharges) if floor(eventPlayer.ZaryaBubbleCharges) > 0 else iconString(Icon.CROSS), iconString(Icon.CHECKMARK) if floor(eventPlayer.ZaryaBubbleCharges) == 2 else ceil(eventPlayer.ZaryaBubbleCooldown)), updateEveryTick(localPlayer.getEyePosition() + (100 * (2.57 * (crossProduct(localPlayer.getFacingDirection(), angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + ((-1.37 - 0.2) * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 1.35, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
  eventPlayer.HeroTexts.append(getLastCreatedText())
  async(CleanupZarya, AsyncBehavior.NOOP)


rule "[zarya.del] Initial":
  @Event eachPlayer
  @Hero zarya
  
  InitialZarya()
