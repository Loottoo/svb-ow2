#!define hardCCd(player) ((player).isDead() or (player).hasStatusEffect(Status.ASLEEP) or (player).hasStatusEffect(Status.KNOCKED_DOWN) or (player).hasStatusEffect(Status.STUNNED) or (player).hasStatusEffect(Status.FROZEN))

#!define specialAbilitiesDisabled(player) ((player).hasStatusEffect(Status.HACKED) or hardCCd(player))
