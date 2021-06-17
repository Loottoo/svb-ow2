#!mainFile "../../main.opy"

rule "[orisa.del] Decrease Primary Fire Movement Speed Penalty":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isFiringPrimaryFire() == true

    _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.OrisaMoveSpeedID])[0]] = 120
    waitUntil(not eventPlayer.isFiringPrimaryFire(), 9999)
    _objectVariable_2[([player for player in ActiveModifications if _objectVariable_0[player] == eventPlayer.OrisaMoveSpeedID])[0]] = 100
