#!include "settings.opy"

#!include "dev.opy"

#!include "general/4M6QT.opy"

#!include "heroes/tanks.opy"
#!include "heroes/healers.opy"
#!include "heroes/damage.opy"

#!include "heroes/mercy/base.opy"
#!include "heroes/mercy/primary-secondary.opy"
#!include "heroes/mercy/angelic-blessing.opy"

#!include "heroes/mei/base.opy"
#!include "heroes/mei/avalanche.opy"
#!include "heroes/mei/seperate-ammo.opy"
#!include "heroes/mei/snowball.opy"
#!include "heroes/mei/icing.opy"

#!include "heroes/echo/base.opy"
#!include "heroes/echo/sticky-bombs.opy"

#!include "heroes/roadhog/ultimate.opy"

#!include "heroes/wrecking-ball/piledriver.opy"

#!include "heroes/ashe/ultimate.opy"

#!include "heroes/genji/primary-secondary.opy"
#!include "heroes/genji/ultimate.opy"
#!include "heroes/genji/deflect.opy"

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

#!include "heroes/zarya/base.opy"
#!include "heroes/zarya/bubbles.opy"

rule "[shared.workshop] Disable Inspector Recording":
    @Condition devMode != true

    disableInspector()
