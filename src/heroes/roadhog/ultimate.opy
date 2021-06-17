#!mainFile "../../main.opy"

def InitialRoadhog():
  @Name "[Sub][Roadhog] Initial - Knockback dealt 80%"
  eventPlayer.setKnockbackDealt(80)

def CleanupRoadhog():
  @Name "[Sub][Roadhog] Cleanup - Restore normal knockback dealt"
  eventPlayer.setKnockbackDealt(100)
