//
//  AppConstants.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI

let homeAppName = "Video Saver"
let splashAppName = "Video Saver"
let remoteConfigAdFetchKey = "VideoSaver"
var interstitialIntergap: Int = 3
var isHideTabBackPremium: Bool = true
var remoteConfigAdShowCount: Int = 3
var restoreShow: Bool = true
var appComesFirst = true
var remoteConfigModel: RemoteAdsModel?

let redThemeColor = Color(red: 202/255, green: 7/255, blue: 15/255) //#CA070F
let pinkThemeColor = Color(red: 251/255, green: 47/255, blue: 72/255) //#FB2F48
let textGrayColor = Color(red: 153/255, green: 153/255, blue: 153/255) //#999999
let pinkOpacityColor = Color(red: 242/255, green: 84/255, blue: 91/255) //#F2545B
let pinkGradientColor = Color(red: 1.0, green: 65/255, blue: 101/255) //#FF4165

let appLink = URL(string: "")
let appRateLink = URL(string: "")
let termsCondition = URL(string: "")
let EULA = URL(string: "")
let privacyPolicy = URL(string: "")

let countryDialingCodes: [String: String] = [
    "AF": "+93",    // Afghanistan
    "AL": "+355",   // Albania
    "DZ": "+213",   // Algeria
    "AS": "+1-684", // American Samoa
    "AD": "+376",   // Andorra
    "AO": "+244",   // Angola
    "AI": "+1-264", // Anguilla
    "AG": "+1-268", // Antigua and Barbuda
    "AR": "+54",    // Argentina
    "AM": "+374",   // Armenia
    "AW": "+297",   // Aruba
    "AU": "+61",    // Australia
    "AT": "+43",    // Austria
    "AZ": "+994",   // Azerbaijan
    "BS": "+1-242", // Bahamas
    "BH": "+973",   // Bahrain
    "BD": "+880",   // Bangladesh
    "BB": "+1-246", // Barbados
    "BY": "+375",   // Belarus
    "BE": "+32",    // Belgium
    "BZ": "+501",   // Belize
    "BJ": "+229",   // Benin
    "BM": "+1-441", // Bermuda
    "BT": "+975",   // Bhutan
    "BO": "+591",   // Bolivia
    "BA": "+387",   // Bosnia and Herzegovina
    "BW": "+267",   // Botswana
    "BR": "+55",    // Brazil
    "IO": "+246",   // British Indian Ocean Territory
    "VG": "+1-284", // British Virgin Islands
    "BN": "+673",   // Brunei
    "BG": "+359",   // Bulgaria
    "BF": "+226",   // Burkina Faso
    "BI": "+257",   // Burundi
    "KH": "+855",   // Cambodia
    "CM": "+237",   // Cameroon
    "CA": "+1",     // Canada
    "CV": "+238",   // Cape Verde
    "KY": "+1-345", // Cayman Islands
    "CF": "+236",   // Central African Republic
    "TD": "+235",   // Chad
    "CL": "+56",    // Chile
    "CN": "+86",    // China
    "CO": "+57",    // Colombia
    "KM": "+269",   // Comoros
    "CK": "+682",   // Cook Islands
    "CR": "+506",   // Costa Rica
    "HR": "+385",   // Croatia
    "CU": "+53",    // Cuba
    "CW": "+599",   // Curaçao
    "CY": "+357",   // Cyprus
    "CZ": "+420",   // Czech Republic
    "CD": "+243",   // Democratic Republic of the Congo
    "DK": "+45",    // Denmark
    "DJ": "+253",   // Djibouti
    "DM": "+1-767", // Dominica
    "DO": "+1-809", // Dominican Republic
    "EC": "+593",   // Ecuador
    "EG": "+20",    // Egypt
    "SV": "+503",   // El Salvador
    "GQ": "+240",   // Equatorial Guinea
    "ER": "+291",   // Eritrea
    "EE": "+372",   // Estonia
    "ET": "+251",   // Ethiopia
    "FJ": "+679",   // Fiji
    "FI": "+358",   // Finland
    "FR": "+33",    // France
    "GF": "+594",   // French Guiana
    "PF": "+689",   // French Polynesia
    "GA": "+241",   // Gabon
    "GM": "+220",   // Gambia
    "GE": "+995",   // Georgia
    "DE": "+49",    // Germany
    "GH": "+233",   // Ghana
    "GI": "+350",   // Gibraltar
    "GR": "+30",    // Greece
    "GL": "+299",   // Greenland
    "GD": "+1-473", // Grenada
    "GP": "+590",   // Guadeloupe
    "GU": "+1-671", // Guam
    "GT": "+502",   // Guatemala
    "GG": "+44",    // Guernsey
    "GN": "+224",   // Guinea
    "GW": "+245",   // Guinea-Bissau
    "GY": "+592",   // Guyana
    "HT": "+509",   // Haiti
    "HN": "+504",   // Honduras
    "HK": "+852",   // Hong Kong
    "HU": "+36",    // Hungary
    "IS": "+354",   // Iceland
    "IN": "+91",    // India
    "ID": "+62",    // Indonesia
    "IR": "+98",    // Iran
    "IQ": "+964",   // Iraq
    "IE": "+353",   // Ireland
    "IM": "+44",    // Isle of Man
    "IL": "+972",   // Israel
    "IT": "+39",    // Italy
    "CI": "+225",   // Ivory Coast
    "JM": "+1-876", // Jamaica
    "JP": "+81",    // Japan
    "JE": "+44",    // Jersey
    "JO": "+962",   // Jordan
    "KZ": "+7",     // Kazakhstan
    "KE": "+254",   // Kenya
    "KI": "+686",   // Kiribati
    "XK": "+383",   // Kosovo
    "KW": "+965",   // Kuwait
    "KG": "+996",   // Kyrgyzstan
    "LA": "+856",   // Laos
    "LV": "+371",   // Latvia
    "LB": "+961",   // Lebanon
    "LS": "+266",   // Lesotho
    "LR": "+231",   // Liberia
    "LY": "+218",   // Libya
    "LI": "+423",   // Liechtenstein
    "LT": "+370",   // Lithuania
    "LU": "+352",   // Luxembourg
    "MO": "+853",   // Macau
    "MK": "+389",   // North Macedonia
    "MG": "+261",   // Madagascar
    "MW": "+265",   // Malawi
    "MY": "+60",    // Malaysia
    "MV": "+960",   // Maldives
    "ML": "+223",   // Mali
    "MT": "+356",   // Malta
    "MH": "+692",   // Marshall Islands
    "MQ": "+596",   // Martinique
    "MR": "+222",   // Mauritania
    "MU": "+230",   // Mauritius
    "YT": "+262",   // Mayotte
    "MX": "+52",    // Mexico
    "FM": "+691",   // Micronesia
    "MD": "+373",   // Moldova
    "MC": "+377",   // Monaco
    "MN": "+976",   // Mongolia
    "ME": "+382",   // Montenegro
    "MS": "+1-664", // Montserrat
    "MA": "+212",   // Morocco
    "MZ": "+258",   // Mozambique
    "MM": "+95",    // Myanmar
    "NA": "+264",   // Namibia
    "NR": "+674",   // Nauru
    "NP": "+977",   // Nepal
    "NL": "+31",    // Netherlands
    "NC": "+687",   // New Caledonia
    "NZ": "+64",    // New Zealand
    "NI": "+505",   // Nicaragua
    "NE": "+227",   // Niger
    "NG": "+234",   // Nigeria
    "NU": "+683",   // Niue
    "NF": "+672",   // Norfolk Island
    "KP": "+850",   // North Korea
    "NO": "+47",    // Norway
    "OM": "+968",   // Oman
    "PK": "+92",    // Pakistan
    "PW": "+680",   // Palau
    "PS": "+970",   // Palestine
    "PA": "+507",   // Panama
    "PG": "+675",   // Papua New Guinea
    "PY": "+595",   // Paraguay
    "PE": "+51",    // Peru
    "PH": "+63",    // Philippines
    "PL": "+48",    // Poland
    "PT": "+351",   // Portugal
    "PR": "+1-787", // Puerto Rico
    "QA": "+974",   // Qatar
    "CG": "+242",   // Republic of the Congo
    "RE": "+262",   // Réunion
    "RO": "+40",    // Romania
    "RU": "+7",     // Russia
    "RW": "+250",   // Rwanda
    "BL": "+590",   // Saint Barthélemy
    "SH": "+290",   // Saint Helena
    "KN": "+1-869", // Saint Kitts and Nevis
    "LC": "+1-758", // Saint Lucia
    "MF": "+590",   // Saint Martin
    "PM": "+508",   // Saint Pierre and Miquelon
    "VC": "+1-784", // Saint Vincent and the Grenadines
    "WS": "+685",   // Samoa
    "SM": "+378",   // San Marino
    "ST": "+239",   // São Tomé and Príncipe
    "SA": "+966",   // Saudi Arabia
    "SN": "+221",   // Senegal
    "RS": "+381",   // Serbia
    "SC": "+248",   // Seychelles
    "SL": "+232",   // Sierra Leone
    "SG": "+65",    // Singapore
    "SX": "+1-721", // Sint Maarten
    "SK": "+421",   // Slovakia
    "SI": "+386",   // Slovenia
    "SB": "+677",   // Solomon Islands
    "SO": "+252",   // Somalia
    "ZA": "+27",    // South Africa
    "KR": "+82",    // South Korea
    "SS": "+211",   // South Sudan
    "ES": "+34",    // Spain
    "LK": "+94",    // Sri Lanka
    "SD": "+249",   // Sudan
    "SR": "+597",   // Suriname
    "SZ": "+268",   // Eswatini
    "SE": "+46",    // Sweden
    "CH": "+41",    // Switzerland
    "SY": "+963",   // Syria
    "TW": "+886",   // Taiwan
    "TJ": "+992",   // Tajikistan
    "TZ": "+255",   // Tanzania
    "TH": "+66",    // Thailand
    "TG": "+228",   // Togo
    "TK": "+690",   // Tokelau
    "TO": "+676",   // Tonga
    "TT": "+1-868", // Trinidad and Tobago
    "TN": "+216",   // Tunisia
    "TR": "+90",    // Turkey
    "TM": "+993",   // Turkmenistan
    "TC": "+1-649", // Turks and Caicos Islands
    "TV": "+688",   // Tuvalu
    "UG": "+256",   // Uganda
    "UA": "+380",   // Ukraine
    "AE": "+971",   // United Arab Emirates
    "GB": "+44",    // United Kingdom
    "US": "+1",     // United States
    "UY": "+598",   // Uruguay
    "UZ": "+998",   // Uzbekistan
    "VU": "+678",   // Vanuatu
    "VA": "+379",   // Vatican City
    "VE": "+58",    // Venezuela
    "VN": "+84",    // Vietnam
    "VI": "+1-340", // U.S. Virgin Islands
    "EH": "+212",   // Western Sahara
    "YE": "+967",   // Yemen
    "ZM": "+260",   // Zambia
    "ZW": "+263"    // Zimbabwe
]
