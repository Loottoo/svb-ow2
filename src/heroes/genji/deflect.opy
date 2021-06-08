#!mainFile "../../main.opy"


def GenjiResetDeflect():
    @Name "[genji.del] Subroutine: Deflect Cooldown Reset"
    
    if not eventPlayer.isUsingUltimate():
        return
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)


rule "[genji.del] Deflect Cooldown Reset":
    @Event playerDealtFinalBlow
    @Hero genji
    
    GenjiResetDeflect()


rule "[genji.del] Deflect Cooldown Reset (Duplication)":
    @Event playerDealtFinalBlow
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.GENJI
    
    GenjiResetDeflect()
