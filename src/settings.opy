#!mainFile "main.opy"

settings {
    "main": {
        "description": "OW2 Changes - SVB Creator Pugs in collab with Elo Hell Workshops Discord."
    },
    "lobby": {
        "spectatorSlots": 6,
        "team1Slots": 5,
        "team2Slots": 5
    },
    "gamemodes": {
        "general": {
            "enableSkins": false,
            "enableKillCam": false,
            "respawnTime%": 80
        },
        "control": {
            "enabledMaps": [],
            "roleLimit": "2OfEachRolePerTeam",
            "enableCompetitiveRules": true
        },
        "escort": {
            "enabledMaps": [],
            "roleLimit": "2OfEachRolePerTeam",
            "enableCompetitiveRules": true
        },
        "hybrid": {
            "enabledMaps": [],
            "roleLimit": "2OfEachRolePerTeam",
            "enableCompetitiveRules": true
        },
        "skirmish": {
            "enabledMaps": [
                "workshopIsland"
            ]
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ability1Cooldown%": 125
            },
            "ashe": {
                "ability1EnemyKb%": 55
            },
            "dva": {
                "secondaryFireMaximumTime%": 200
            },
            "hanzo": {
                "ability3Distance%": 135,
                "ability2Cooldown%": 0,
                "ability2Quantity%": 12
            },
            "junkrat": {
                "ability2Cooldown%": 70
            },
            "echo": {
                "ability1Cooldown%": 116
            },
            "reinhardt": {
                "ability1Cooldown%": 80
            },
            "sigma": {
                "ability1Cooldown%": 75
            }
        }
    },
    "workshop": {
        "What button should Icing overwrite?": [
            1
        ],
        "Snowball time between shots": 0.5,
        "Enable Snowball instead of regular right click": false,
        "Steps (Higher = more circles on the ground)": 15
    }
}
