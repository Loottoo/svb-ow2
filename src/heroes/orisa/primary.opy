#!mainFile "../../main.opy"

rule "[orisa.del] Decrease Primary Fire Movement Speed Penalty":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isFiringPrimaryFire() == true

    eventPlayer.HeroAbsoluteSpeedMod = 495/3.85
    waitUntil(not eventPlayer.isFiringPrimaryFire(), 9999)
    if eventPlayer.HeroAbsoluteSpeedMod == 495/3.85:
        eventPlayer.HeroAbsoluteSpeedMod = 100
