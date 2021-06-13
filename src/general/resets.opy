#!mainFile "../main.opy"


playervar hero

rule "Player changed hero":
    @Event eachPlayer
    @Condition (not(eventPlayer.isDuplicatingAHero()) and eventPlayer.hero != eventPlayer.getCurrentHero()) or (eventPlayer.isDuplicatingAHero() and eventPlayer.hero != eventPlayer.getHeroOfDuplication())
    do:
        eventPlayer.hero = eventPlayer.getHeroOfDuplication() if eventPlayer.isDuplicatingAHero() else eventPlayer.getCurrentHero()

        eventPlayer.setPrimaryFireEnabled(eventPlayer.hero not in [
            Hero.DOOMFIST,
        ])
        eventPlayer.setSecondaryFireEnabled(true)
        eventPlayer.setAbility1Enabled(eventPlayer.hero not in [
            Hero.REINHARDT,
            Hero.TRACER,
        ])
        eventPlayer.setAbility2Enabled(eventPlayer.hero not in [
            Hero.TRACER,
        ])
        eventPlayer.setUltEnabled(eventPlayer.hero not in [
            Hero.DOOMFIST,
            Hero.DVA,
            Hero.PHARAH,
            Hero.JUNKRAT,
        ])
        eventPlayer.setMeleeEnabled(true)

        if eventPlayer.hero in [Hero.DOOMFIST]:
            eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
        else:
            eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)

        eventPlayer.setMaxHealth(8/9 * 100 if eventPlayer.hero == Hero.MCCREE else 92.857 if eventPlayer.hero == Hero.WINSTON else 100)

        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.allowButton(Button.ABILITY_1)
        eventPlayer.allowButton(Button.ABILITY_2)
        eventPlayer.allowButton(Button.ULTIMATE)
        eventPlayer.allowButton(Button.INTERACT)

        eventPlayer.setDamageDealt(100)
        eventPlayer.setGravity(100)
        eventPlayer.setJumpVerticalSpeed(100)
        eventPlayer.setProjectileGravity(100)
        eventPlayer.setProjectileSpeed(100)
        eventPlayer.stopForcingThrottle()
        eventPlayer.stopFacing()
        eventPlayer.stopCamera()
        eventPlayer.enablePlayerCollision()

        wait()
    while RULE_CONDITION
