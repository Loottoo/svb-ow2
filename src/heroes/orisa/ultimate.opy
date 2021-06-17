#!mainFile "../../main.opy"


rule "[orisa.del] Ultimate":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.TemporaryCooldown = eventPlayer.getAbilityCooldown(Button.ABILITY_2)
    eventPlayer.CastingUltimate = true
    #Deploy shield
    eventPlayer.setProjectileSpeed(50)
    eventPlayer.setProjectileGravity(abs(1000))
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    #Wait until shield is deployed
    waitUntil(not eventPlayer.isUsingAbility2(), 9999)
    #Reset
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.TemporaryCooldown)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setProjectileSpeed(125)
    eventPlayer.CastingUltimate = false
