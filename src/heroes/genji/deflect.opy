#!mainFile "../../main.opy"

rule "[genji.del] Deflect Cooldown Reset":
    @Event playerDealtFinalBlow
    @Condition eventPlayer.hero == Hero.GENJI
    @Condition not eventPlayer.isUsingUltimate()
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
