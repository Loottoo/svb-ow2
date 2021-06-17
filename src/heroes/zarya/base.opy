#!mainFile "../../main.opy"


globalvar ZaryaBubbleCooldown = createWorkshopSetting(float[1:15], "Zarya", "Bubble Cooldown", 7, 0)
globalvar ZaryaBubbleMaxCharges = createWorkshopSetting(int[1:5], "Zarya", "Max bubble charges", 2, 1)


def CleanupZarya():
  @Name "[zarya.del] Subroutine: Cleanup"
  
  CleanupTexts()
  eventPlayer.setAbility1Enabled(true)
  eventPlayer.setAbility2Enabled(true)
  stopChasingVariable(eventPlayer.ZaryaBubbleCooldown)


def InitialZarya():
  @Name "[zarya.del] Subroutine: Initial"
  
  #Variable setup
  eventPlayer.ZaryaBubbleCharges = ZaryaBubbleMaxCharges
  eventPlayer.ZaryaBubbleCooldown = ZaryaBubbleCooldown
  chase(eventPlayer.ZaryaBubbleCooldown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
  createInWorldText(null if eventPlayer.isCommunicatingEmote() or eventPlayer.isDead() else eventPlayer, "({0}) [{1}]".format(floor(eventPlayer.ZaryaBubbleCharges) if floor(eventPlayer.ZaryaBubbleCharges) > 0 else iconString(Icon.CROSS), iconString(Icon.CHECKMARK) if floor(eventPlayer.ZaryaBubbleCharges) == 2 else ceil(eventPlayer.ZaryaBubbleCooldown)), updateEveryTick(localPlayer.getEyePosition() + (100 * (2.27 * (crossProduct(localPlayer.getFacingDirection(), angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + ((-1.37 - 0.2) * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 1.3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
  eventPlayer.HeroTexts.append(getLastCreatedText())
  createInWorldText(null if eventPlayer.isCommunicatingEmote() or eventPlayer.isDead() else eventPlayer, "({0}) [{1}]".format(floor(eventPlayer.ZaryaBubbleCharges) if floor(eventPlayer.ZaryaBubbleCharges) > 0 else iconString(Icon.CROSS), iconString(Icon.CHECKMARK) if floor(eventPlayer.ZaryaBubbleCharges) == 2 else ceil(eventPlayer.ZaryaBubbleCooldown)), updateEveryTick(localPlayer.getEyePosition() + (100 * (2.57 * (crossProduct(localPlayer.getFacingDirection(), angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + ((-1.37 - 0.2) * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 1.35, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
  eventPlayer.HeroTexts.append(getLastCreatedText())

