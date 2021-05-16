Config = {}
Config.Locale = 'en'

Config.useESXAdvancedGarage = false

Config.giveCautionToSociety = true
Config.society = 'society_police'

Config.Jobname = 'police'
Config.Jobname2 = 'police'
Config.Jobname3 = 'police'

Config.Impounder = {

    {
        name = 'Police Impound',
        blipSprite = 67,
        blipColor = 17,
        loc = {x = 396.8, y = -1638.2, z = 29.29, rot = 322.07},
        pedModel = 's_m_y_garbage',
        park = {x = 401.35, y = -1632.19, z = 29.29, rot = 322.6},
        spawn = {x = 401.36, y = -1647.98, z = 29.29, rot = 318.54},
    },

    {
        name = 'City Impound',
        blipSprite = 67,
        blipColor = 17,
        loc = {x = 490.67, y = -1318.1, z = 29.24, rot = 324.07},
        pedModel = 's_m_y_garbage',
        park = {x = 489.61, y = -1313.27, z = 29.26, rot = 290.0},
        spawn = {x = 489.61, y = -1313.27, z = 29.26, rot = 290.0},
    },

    {
        name = 'Boat Impound',
        blipSprite = 410,
        blipColor = 17,
        loc = {x = -788.38, y = -1490.3, z = 1.6, rot = 289.21},
        pedModel = 's_m_y_uscg_01',
        park = {x = -795.29, y = -1502.06, z = -0.47, rot = 109.6},
        spawn = {x = -797.84, y = -1490.21, z = -0.47, rot = 301.0},
    },

}

Translation = {
    ['de'] = {
        ['interact_impound'] = 'Drücke ~g~E~s~, um abgeschleppte Fahrzeuge anzuzeigen',
        ['impound'] = 'Impound',
        ['my_impounded_vehicles'] = 'Meine beschlagnahmten Fahrzeuge',
        ['vehicle_model'] = 'Fahrzeugmodell: ',
        ['plate'] = 'Kennzeichen: ',
        ['impound_at'] = 'Beschlagnahmt am: ',
        ['impound_by'] = 'Beschlagnahmt von: ',
        ['caution_allowed'] = 'Zur Kaution freigegeben? ',
        ['desc_impound_by'] = 'Beschlagnahmt von ~b~',
        ['yes'] = '~g~Ja',
        ['no'] = '~r~Nein',
        ['caution'] = 'Kaution: ',
        ['pay_caution'] = 'Kaution bezahlen',
        ['caution_paid'] = 'Dein Fahrzeug ~s~mit dem Kennzeichen ~y~',
        ['caution_paid2'] = ' ~s~wurde für ~r~ ',
        ['caution_paid3'] = '$ ~s~wieder freigegeben.',
        ['not_enough_money'] = '~r~Du hast nicht genügend Geld!',
        ['impound_vehicle'] = 'Fahrzeug beschlagnahmen',
        ['impound_vehicle_final'] = '~r~Fahrzeug beschlagnahmen',
        ['check_caution_allowed'] = 'Zur Kaution freigeben?',
        ['set_caution'] = 'Kaution festlegen',
        ['vehicle_has_no_owner'] = '~r~Das Fahrzeug hat keinen Besitzer!',
        ['impounded_vehicles'] = 'Beschlagnahmte Fahrzeuge',
        ['vehicle_of'] = 'Fahrzeug von ',
        ['impounded_by'] = 'Beschlagnahmt von ~b~',
        ['caution_changed_true'] = '~g~Das Fahrzeug wurde auf Kaution freigegeben.',
        ['caution_changed_false'] = '~g~Das Fahrzeug ist nun nicht mehr auf Kaution freigegeben.',
        ['release_vehicle'] = 'Fahrzeug freigeben',
        ['released_vehicle'] = 'Das Fahrzeug mit dem Kennzeichen ~y~',
        ['released_vehicle2'] = ' ~s~wurde ~g~freigegeben~s~.',
        ['vehicle_impounded'] = 'Das Fahrzeug mit dem Kennzeichen ~y~',
        ['vehicle_impounded2'] = ' ~s~wurde beschlagnahmt',
    },

    ['en'] = {
        ['interact_impound'] = 'Press ~g~E~s~, to access the Impound',
        ['impound'] = 'Impound',
        ['my_impounded_vehicles'] = 'My impounded vehicles',
        ['vehicle_model'] = 'Vehicle model: ',
        ['plate'] = 'Plate: ',
        ['impound_at'] = 'Impounded at: ',
        ['impound_by'] = 'Impounded by: ',
        ['caution_allowed'] = 'Accessable with security deposit? ',
        ['desc_impound_by'] = 'Impounded by ~b~',
        ['yes'] = '~g~Yes',
        ['no'] = '~r~No',
        ['caution'] = 'Security deposit: ',
        ['pay_caution'] = 'Pay the security deposit',
        ['caution_paid'] = 'Your vehicle ~s~with the plate ~y~',
        ['caution_paid2'] = ' ~s~was released for ~r~ ',
        ['caution_paid3'] = '$ ~s~.',
        ['not_enough_money'] = '~r~You do not have enough money!',
        ['impound_vehicle'] = 'Impound vehicle',
        ['impound_vehicle_final'] = '~r~Impound vehicle',
        ['check_caution_allowed'] = 'Allow security deposit?',
        ['set_caution'] = 'Set security deposit',
        ['vehicle_has_no_owner'] = '~r~Tis vehicle does not have an owner!',
        ['impounded_vehicles'] = 'Impounded vehicles',
        ['vehicle_of'] = 'Vehicle of ',
        ['impounded_by'] = 'Impounded by ~b~',
        ['caution_changed_true'] = '~g~The vehicle is now accessable with a security deposit.',
        ['caution_changed_false'] = '~g~This vehicle can not be accessed with a security deposit anymore.',
        ['release_vehicle'] = 'Release vehicle',
        ['released_vehicle'] = 'The vehicle with the plate ~y~',
        ['released_vehicle2'] = ' ~s~was ~g~released~s~.',
        ['vehicle_impounded'] = 'The vehicle with the plate ~y~',
        ['vehicle_impounded2'] = ' ~s~was ~g~impounded~s~!',
    }
}