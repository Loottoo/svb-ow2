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
            "enableSkins": false
        },
        "assault": {
            "enabledMaps": [],
            "roleLimit": "2OfEachRolePerTeam",
            "enableCompetitiveRules": true
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
            "ashe": {
                "ability1EnemyKb%": 55
            },
            "dva": {
                "secondaryFireMaximumTime%": 200
            },
            "hanzo": {
                "projectileSpeed%": 115,
                "ability2Quantity%": 4
            },
            "junkrat": {
                "ability2Cooldown%": 70
            },
            "echo": {
                "ability1Cooldown%": 116
            },
            "reinhardt": {
                "ability1Cooldown%": 80
            }
        }
    },
    "workshop": {
        "What button should Icing overwrite?": [
            1
        ],
        "Snowball time between shots": 0.5,
        "Enable Snowball instead of regular right click": false,
        "Steps (Higher = more circles on the ground)": 15,
        "Turn Speed (if enabled)": 100,
        "Avalanche Radius": 2.5,
        "Avalanche max speed": 300
    }
}
