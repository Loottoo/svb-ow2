#!mainFile "../main.opy"


subroutine CheckStatus


#this is useless right?
def CheckStatus():
    @Name "[SUB] Check Status"
    
    if eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.STUNNED):
        return
    if eventPlayer.isDead():
        return
