#!mainFile "../../main.opy"

rule "[Mei] Deal extra damage on primary fire":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, createWorkshopSetting(float[0:100], "Mei", "Weapon Freeze Damage Boost", 20) / 100 * eventDamage)
