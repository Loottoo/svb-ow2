#!mainFile "main.opy"

settings {
    "main": {
        "description": "OW2 Changes - SVB Creator Pugs in collab with Elo Hell Workshops Discord."
    },
    "lobby": {
        "team1Slots": 5,
        "team2Slots": 5
    },
    "gamemodes": {
        "assault": {
            "enabledMaps": [],
            "roleLimit": "2OfEachRolePerTeam"
        },
        "control": {
            "enabledMaps": [],
            "roleLimit": "2OfEachRolePerTeam"
        },
        "escort": {
            "enabledMaps": [],
            "roleLimit": "2OfEachRolePerTeam"
        },
        "hybrid": {
            "enabledMaps": [],
            "roleLimit": "2OfEachRolePerTeam"
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
                "ability1Cooldown%": 70
            }
        }
    },
    "workshop": {
        "What button should Icing overwrite?": [
            1
        ],
        "Enable Snowball instead of regular right click": true,
        "Snowball time between shots": 0.5,
        "Enable Snowball instead of regular right click": false
    }
}
