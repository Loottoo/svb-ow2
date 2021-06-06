#!mainFile "../../main.opy"


globalvar OverwriteButtonArray
globalvar SeparateAmmoEnabled


rule "Initial":
    OverwriteButtonArray = [null, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2]
