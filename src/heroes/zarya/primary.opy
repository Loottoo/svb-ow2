#!mainFile "../../main.opy"


globalvar zaryaReducePrimaryPercentage = createWorkshopSetting(int[0:100], "Zarya", "Reduce Primary Fire damage by percentage", 12, 5)


rule "Zarya is firing primary":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isFiringPrimaryFire()
    
    eventPlayer.setDamageDealt(100 - zaryaReducePrimaryPercentage)

    waitUntil(eventPlayer.isFiringPrimaryFire() != true, 10)

    eventPlayer.setDamageDealt(100)


rule "Zarya is firing primary":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.ZARYA
    @Condition eventPlayer.isFiringPrimaryFire()
    
    eventPlayer.setDamageDealt(100 - zaryaReducePrimaryPercentage)
  
    waitUntil(eventPlayer.isFiringPrimaryFire() != true, 10)
  
    eventPlayer.setDamageDealt(100)
