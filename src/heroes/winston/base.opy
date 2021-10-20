#!mainFile "../../main.opy"


globalvar ZapCharges = 1
globalvar ZapCooldown = createWorkshopSetting(int[0:20], "Winston", "Zap Cooldown time", 2, 0)
globalvar ZapChargeTime = createWorkshopSetting(float[0:10], "Winston", "Zap Charge time", 1, 0)
globalvar ZapDamage = createWorkshopSetting(int[0:500], "Winston", "Zap Damage", 50, 0)
globalvar ZapRange = createWorkshopSetting(float[0:500], "Winston", "Zap Range", 20, 0)
globalvar ZapRadius = createWorkshopSetting(float[0:2], "Winston", "Zap Projectile Size", 0.5, 0)
globalvar ZapHitboxArray
globalvar ZapLoop

playervar ZapChargeMeter
playervar DeletableHUD
playervar ZapHUDSpacer
playervar ZapEffects
playervar ZapHudProgress
playervar ZapHitPlayer
playervar p_ZapCharges


def CleanupWinston():
    @Name "[winston.del] Subroutine: Cleanup"

    CleanupHealthPools()
    CleanupTexts()


def InitialWinston():
    @Name "[winston.del] Subroutine: Initial"

    #Character setup
    eventPlayer.addHealthPool(Health.NORMAL, 110.714 if eventPlayer.isUsingUltimate() else 75, true, true)
    eventPlayer.HeroHealthPools.append(getLastCreatedHealthPool())
    eventPlayer.addHealthPool(Health.ARMOR, 10.7, true, true)
    eventPlayer.HeroHealthPools.append(getLastCreatedHealthPool())
    eventPlayer.p_ZapCharges = ZapCharges
    hudSubheader(eventPlayer, " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.RIGHT, 20, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.HeroTexts.append(getLastCreatedText())
    hudText(eventPlayer, ceil(ZapCooldown - eventPlayer.ZapChargeMeter) if eventPlayer.p_ZapCharges == 0 else iconString(Icon.BOLT), null, "{0}".format(buttonString(Button.SECONDARY_FIRE)), HudPosition.RIGHT, 21, Color.RED if eventPlayer.p_ZapCharges == 0 else Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    eventPlayer.HeroTexts.append(getLastCreatedText())

