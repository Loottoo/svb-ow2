#!mainFile "../../main.opy"


globalvar MaxAmmoPrimary
globalvar MaxAmmoSecondary
globalvar SeparateAmmoAutoReload


playervar CurrentAmmoPrimary 46
playervar CurrentAmmoSecondary 47


rule "Initialise":
  SeparateAmmoEnabled = createWorkshopSetting(bool, "Separate ammo counter", "Use seperate ammo pool for Primary and Secondary fire", false, 0)
  MaxAmmoPrimary = createWorkshopSetting(int[30:100], "Separate ammo counter", "Primary Fire Max Ammo", 50, 1)
  MaxAmmoSecondary = createWorkshopSetting(int[10:200], "Separate ammo counter", "Secondary Fire Max Ammo", 100, 2)
  SeparateAmmoAutoReload = createWorkshopSetting(bool, "Separate ammo counter", "Auto reload when either primary or secondary is empty", false, 3)


rule "HUD":
  @Condition SeparateAmmoEnabled == true
  
  hudText([i for i in localPlayer if localPlayer.getCurrentHero() == Hero.MEI and true], null, " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.RIGHT, 99, null, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
  hudHeader([player for player in getAllPlayers() if localPlayer.getCurrentHero() == Hero.MEI], "{0} {2} {1}".format("{0}/{1}".format(localPlayer.CurrentAmmoPrimary, MaxAmmoPrimary), "{0}/{1}".format(ceil(localPlayer.CurrentAmmoSecondary), MaxAmmoSecondary), abilityIconString(Hero.MEI, Button.PRIMARY_FIRE)), HudPosition.RIGHT, 100, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)


rule "Set max ammo":
  @Event eachPlayer
  @Hero mei
  @Condition SeparateAmmoEnabled == true
  
  eventPlayer.setMaxAmmo(0, 999)
  eventPlayer.setAmmo(0, 999)
  eventPlayer.CurrentAmmoPrimary = MaxAmmoPrimary
  eventPlayer.CurrentAmmoSecondary = MaxAmmoSecondary


rule "Is firing secondary - Subtract ammo with chase":
  @Event eachPlayer
  @Hero mei
  @Condition SeparateAmmoEnabled == true
  @Condition eventPlayer.isFiringSecondaryFire() == true
  
  chase(eventPlayer.CurrentAmmoSecondary, eventPlayer.CurrentAmmoSecondary - 10, duration=0.2, ChaseReeval.NONE)


rule "Secondary is empty - Disable secondary until it's no longer empty":
  @Event eachPlayer
  @Condition SeparateAmmoEnabled == true
  @Condition eventPlayer.CurrentAmmoSecondary == 0
  
  wait(0.25, Wait.ABORT_WHEN_FALSE)
  eventPlayer.setSecondaryFireEnabled(false)
  #Automatically reload if enabled in Workshop Settings
  if SeparateAmmoAutoReload:
      eventPlayer.forceButtonPress(Button.RELOAD)
  #Wait until ammo is no longer empty
  waitUntil(eventPlayer.CurrentAmmoSecondary > 0, 99999)
  eventPlayer.setSecondaryFireEnabled(true)


rule "Is firing primary - Subtract ammo":
  @Event eachPlayer
  @Condition SeparateAmmoEnabled == true
  @Condition eventPlayer.isFiringPrimaryFire() == true
  
  eventPlayer.CurrentAmmoPrimary -= 1
  wait(0.048, Wait.ABORT_WHEN_FALSE)
  if RULE_CONDITION:
      goto RULE_START


rule "Primary is empty - Disable secondary until it's no longer empty":
  @Event eachPlayer
  @Condition SeparateAmmoEnabled == true
  @Condition eventPlayer.CurrentAmmoPrimary == 0
  
  eventPlayer.setPrimaryFireEnabled(false)
  #Automatically reload if enabled in Workshop Settings
  if SeparateAmmoAutoReload:
      eventPlayer.forceButtonPress(Button.RELOAD)
  #Wait until primary is no longer empty
  waitUntil(eventPlayer.CurrentAmmoPrimary > 0, 99999)
  eventPlayer.setPrimaryFireEnabled(true)


rule "Both Primary and Secondary are empty - Reload":
  @Event eachPlayer
  @Hero mei
  @Condition SeparateAmmoEnabled == true
  @Condition eventPlayer.CurrentAmmoPrimary == 0
  @Condition eventPlayer.CurrentAmmoSecondary == 0
  
  eventPlayer.forceButtonPress(Button.RELOAD)


rule "Is reloading":
  @Event eachPlayer
  @Hero mei
  @Condition SeparateAmmoEnabled == true
  @Condition eventPlayer.isReloading() == true
  
  wait(0.75)
  stopChasingVariable(eventPlayer.CurrentAmmoSecondary)
  eventPlayer.setAmmo(0, 999)
  eventPlayer.CurrentAmmoPrimary = MaxAmmoPrimary
  eventPlayer.CurrentAmmoSecondary = MaxAmmoSecondary


rule "Trying to fire when either is empty":
  @Event eachPlayer
  @Condition SeparateAmmoEnabled == true
  #If firing primary with 0 ammo, or if firing secondary with 0 ammo
  @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and not eventPlayer.CurrentAmmoPrimary or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and not eventPlayer.CurrentAmmoSecondary) == true
  @Condition SeparateAmmoAutoReload != true
  
  playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 25)
