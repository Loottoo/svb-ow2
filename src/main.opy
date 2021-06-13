# 81N8C

#!include "settings.opy"


playervar hero

rule "Player changed hero":
    @Event eachPlayer
    @Condition eventPlayer.hero != eventPlayer.getCurrentHero() or eventPlayer.hero != eventPlayer.getHeroOfDuplication()
    do:
        eventPlayer.hero = eventPlayer.getHeroOfDuplication() or eventPlayer.getCurrentHero()

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

#!include "dev.opy"

#!include "general/4M6QT.opy"
#!include "general/global.opy"

#!include "heroes/tanks.opy"
#!include "heroes/healers.opy"
#!include "heroes/damage.opy"

#!include "heroes/mercy/base.opy"
#!include "heroes/mercy/primary-secondary.opy"
#!include "heroes/mercy/angelic-blessing.opy"

#!include "heroes/mei/avalanche.opy"
#!include "heroes/mei/seperate-ammo.opy"
#!include "heroes/mei/icing.opy"

#!include "heroes/echo/base.opy"
#!include "heroes/echo/sticky-bombs.opy"

#!include "heroes/roadhog/take-a-breather.opy"
#!include "heroes/roadhog/ultimate.opy"

#!include "heroes/wrecking-ball/piledriver.opy"

#!include "heroes/ashe/ultimate.opy"

#!include "heroes/genji/primary-secondary.opy"
#!include "heroes/genji/ultimate.opy"
#!include "heroes/genji/deflect.opy"

#!include "heroes/ana/genjiNano.opy"

#!include "heroes/hanzo/primary.opy"

#!include "heroes/reaper/wraith-form.opy"

#!include "heroes/soldier/sprint.opy"

#!include "heroes/symmetra/base.opy"
#!include "heroes/symmetra/teleporter.opy"
#!include "heroes/symmetra/clone.opy"

#!include "heroes/reinhardt/base.opy"
#!include "heroes/reinhardt/charge.opy"
#!include "heroes/reinhardt/firestrike.opy"

#!include "heroes/baptiste/base.opy"
#!include "heroes/baptiste/immortality.opy"

#!include "heroes/winston/base.opy"
#!include "heroes/winston/zap.opy"

#!include "heroes/widowmaker/base.opy"
#!include "heroes/widowmaker/primary-secondary.opy"

#!include "heroes/orisa/base.opy"
#!include "heroes/orisa/gallop.opy"
#!include "heroes/orisa/primary.opy"
#!include "heroes/orisa/ultimate.opy"

#!include "heroes/sombra/base.opy"
#!include "heroes/sombra/hack.opy"

#!include "heroes/lucio/base.opy"
#!include "heroes/lucio/speedboost.opy"
#!include "heroes/lucio/ultimate.opy"

#!include "heroes/mccree/base.opy"
#!include "heroes/mccree/lasso.opy"

#!include "heroes/zarya/base.opy"
#!include "heroes/zarya/bubbles.opy"
#!include "heroes/zarya/primary.opy"

#!include "heroes/doomfist/base.opy"
#!include "heroes/doomfist/primary.opy"
#!include "heroes/doomfist/rocket-punch.opy"
#!include "heroes/doomfist/ultimate.opy"

#!include "heroes/dva/baby.opy"

#!include "heroes/zenyatta/shield.opy"

