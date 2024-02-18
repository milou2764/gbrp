local meth1
local cocaine1
local gundealer
local launderer
local cf_export_van
SetGlobalInt("yakuzasBalance",0);
SetGlobalInt("yakuzasPrivateDoorsCount",0);
SetGlobalInt("mafiaBalance",0);
SetGlobalInt("mafiaPrivateDoorsCount",0);
SetGlobalInt("gangBalance",0);
SetGlobalInt("gangPrivateDoorsCount",0);
SetGlobalInt("propertyTax",0);
SetGlobalInt("housingTax",0);
SetGlobalInt("incomeTax",0);
SetGlobalInt("VAT",0);

gbrp = {}
gbrp.taxSpeed = 1800
gbrp.tax = {}
gbrp.defiscalize = {}
gbrp.tax.propertyTax = {
    [1] = 85000,
    [2] = 170000,
    [3] = 340000,
    [4] = 680000,
    [5] = 1360000,
    [6] = 1360000,
}
gbrp.tax.housingTax = {
    [1] = 50000,
    [2] = 100000,
    [3] = 200000,
    [4] = 400000,
    [5] = 800000,
    [6] = 800000,
}
gbrp.tax.incomeTax = {
    [1] = 70000,
    [2] = 140000,
    [3] = 280000,
    [4] = 560000,
    [5] = 1120000,
    [6] = 1120000,
}
gbrp.tax.VAT = {
    [1] = 25000,
    [2] = 50000,
    [3] = 100000,
    [4] = 200000,
    [5] = 400000,
    [6] = 400000,
}
gbrp.defiscalize.propertyTax = {
    [0] = 85000,
    [1] = 170000,
    [2] = 340000,
    [3] = 680000,
    [4] = 1360000,
}
gbrp.defiscalize.housingTax = {
    [0] = 50000,
    [1] = 100000,
    [2] = 200000,
    [3] = 400000,
    [4] = 800000,
}
gbrp.defiscalize.incomeTax = {
    [0] = 70000,
    [1] = 140000,
    [2] = 280000,
    [3] = 560000,
    [4] = 1120000,
}
gbrp.defiscalize.VAT = {
    [0] = 25000,
    [1] = 50000,
    [2] = 100000,
    [3] = 200000,
    [4] = 400000,
}
gbrp.doors = {}
gbrp.startingFunds = 100000
gbrp.doorgroups = {
    ["1 Mapple Rd"] = {doors = {2237,2236,2240,2243,2244,2246},locked = true,attributes = {owner = nil,buyable = true,price = 80000,value = 64000,doorgroup = "1 Mapple Rd",typ = "house"}};
    ["2 Mapple Rd"] = {doors = {2261,2245,2264,2265,2263,2262},locked = true,attributes = {owner = nil,buyable = true,price = 95000,value = 76000,doorgroup = "2 Mapple Rd",typ = "house"}};
    ["3 Mapple Rd"] = {doors = {2268,2271,2272,2270,2269,2267},locked = true,attributes = {owner = nil,buyable = true,price = 105000,value = 84000,doorgroup = "3 Mapple Rd",typ = "house"}};
    ["4 Mapple Rd"] = {doors = {2238,2277,2278,4875,2276,2274},locked = true,attributes = {owner = nil,buyable = true,price = 100000,value = 80000,doorgroup = "4 Mapple Rd",typ = "house"}};
    ["5 Mapple Rd"] = {doors = {2313,2318,2319,2317,2316,2314},locked = true,attributes = {owner = nil,buyable = true,price = 125000,value = 100000,doorgroup = "5 Mapple Rd",typ = "house"}};
    ["6 Mapple Rd"] = {doors = {2414,2409,4876,4873,2410,2239},locked = true,attributes = {owner = nil,buyable = true,price = 115000,value = 92000,doorgroup = "6 Mapple Rd",typ = "house"}};
    ["7 Mapple Rd"] = {doors = {2286,2288,2291,2290,2289,2287},locked = true,attributes = {owner = nil,buyable = true,price = 120000,value = 96000,doorgroup = "7 Mapple Rd",typ = "house"}};
    ["8 Mapple Rd"] = {doors = {2534,2304,2307,2306,2305,2287},locked = true,attributes = {owner = nil,buyable = true,price = 110000,value = 88000,doorgroup = "8 Mapple Rd",typ = "house"}};
    ["9 Mapple Rd"] = {doors = {2509,2417,4874,4877,2416,2415},locked = true,attributes = {owner = "gang",buyable = true,price = 100000,value = 80000,doorgroup = "9 Mapple Rd",typ = "house"}};
    ["gunshop"] = {doors = {2608,2610,2609},locked = false,attributes = {owner = nil,buyable = false,price = 712000,value = 612000,doorgroup = "armory",typ = "shop"}};
    ["bar"] = {doors = {2712,2742,2779,2771,2744},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 100000,doorgroup = "bar",typ = "shop"}};
    ["NYPD open"] = {doors = {2791,2790},locked = false,attributes = {owner = "NYPD",buyable = false,price = 10000,value = 8000,doorgroup = "NYPD open",typ = "NYPD"}};
    ["NYPD closed"] = {doors = {2792,2793,2811,4200,2806,2808,2807,2875,2796,2797,2846,2847,2845,2849,2844,2848,2824,2822,2819,2812,2798,2917,2918,2916,2915,2801,2853,2802,2803,2809,2810},locked = true,attributes = {owner = "NYPD",buyable = false,price = 10000,value = 8000,doorgroup = "NYPD closed",typ = "NYPD"}};
    ["Caserne des pompiers"] = {doors = {2214,2227,2226,2213},locked = true,attributes = {owner = "NYPD",buyable = false,price = 1,value = 1,doorgroup = "Caserne des pompiers",typ = "NYPD"}};
    ["1 Haviture Way"] = {doors = {2002,2001},locked = true,attributes = {owner = nil,buyable = true,price = 50000,value = 40000,doorgroup = "1 Haviture Way",typ = "hangar"}};
    ["1 Grand Way"] = {doors = {3569,3574},locked = true,attributes = {owner = nil,buyable = true,price = 60000,value = 40000,doorgroup = "1 Grand Way",typ = "appartment"}};
    ["2 Grand Way"] = {doors = {3600,3577},locked = true,attributes = {owner = nil,buyable = true,price = 65000,value = 52000,doorgroup = "2 Grand Way",typ = "appartment"}};
    ["3 Grand Way"] = {doors = {3601,3583},locked = true,attributes = {owner = nil,buyable = true,price = 67500,value = 54000,doorgroup = "3 Grand Way",typ = "appartment"}};
    ["4 Grand Way"] = {doors = {3602,3581},locked = true,attributes = {owner = nil,buyable = true,price = 72500,value = 58000,doorgroup = "4 Grand Way",typ = "appartment"}};
    ["5 Grand Way"] = {doors = {3603,3560},locked = true,attributes = {owner = "yakuzas",buyable = true,price = 77500,value = 62000,doorgroup = "5 Grand Way",typ = "appartment"}};
    ["6 Grand Way"] = {doors = {3604,3565},locked = true,attributes = {owner = nil,buyable = true,price = 80000,value = 64000,doorgroup = "6 Grand Way",typ = "appartment"}};
    ["1 River Rd"] = {doors = {2033},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "1 River Rd",typ = "garage"}};
    ["2 River Rd"] = {doors = {2034},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "2 River Rd",typ = "garage"}};
    ["3 River Rd"] = {doors = {2030},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "3 River Rd",typ = "garage"}};
    ["4 River Rd"] = {doors = {2000},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "4 River Rd",typ = "garage"}};
    ["5 River Rd"] = {doors = {2032},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "5 River Rd",typ = "garage"}};
    ["6 River Rd"] = {doors = {2031},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "6 River Rd",typ = "garage"}};
    ["7 River Rd"] = {doors = {2035},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "7 River Rd",typ = "garage"}};
    ["8 River Rd"] = {doors = {2036},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "8 River Rd",typ = "garage"}};
    ["NYPD Hangar"] = {doors = {2018,2008,2007,2555,2302,2301,2019 },locked = true,attributes = {owner = "NYPD",buyable = false,price = 10000,value = 8000,doorgroup = "NYPD Hangar",typ = "NYPD"}};
    ["10 River Rd"] = {doors = {2005,2004,2220,2221},locked = true,attributes = {owner = nil,buyable = true,price = 75000,value = 60000,doorgroup = "10 River Rd",typ = "hangar"}};
    ["11 River Rd"] = {doors = {2021},locked = true,attributes = {owner = nil,buyable = true,price = 85000,value = 68000,doorgroup = "11 River Rd",typ = "house"}};
    ["1 Any Way"] = {doors = {3852,3867},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "1 Any Way",typ = "appartment"}};
    ["2 Any Way"] = {doors = {3849,3861},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "2 Any Way",typ = "appartment"}};
    ["3 Any Way"] = {doors = {3848,3859},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "3 Any Way",typ = "appartment"}};
    ["4 Any Way"] = {doors = {3840,3844},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "4 Any Way",typ = "appartment"}};
    ["5 Any Way"] = {doors = {3845,2341},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "5 Any Way",typ = "appartment"}};
    ["6 Any Way"] = {doors = {3851,3865},locked = true,attributes = {owner = nil,buyable = true,price = 20000,value = 16000,doorgroup = "6 Any Way",typ = "appartment"}};
    ["7 Any Way"] = {doors = {3847,3857},locked = true,attributes = {owner = nil,buyable = true,price = 20000,value = 16000,doorgroup = "7 Any Way",typ = "appartment"}};
    ["8 Any Way"] = {doors = {3850,3863},locked = true,attributes = {owner = nil,buyable = true,price = 20000,value = 16000,doorgroup = "8 Any Way",typ = "appartment"}};
    ["9 Any Way"] = {doors = {3839,3842},locked = true,attributes = {owner = nil,buyable = true,price = 20000,value = 16000,doorgroup = "9 Any Way",typ = "appartment"}};
    ["10 Any Way"] = {doors = {3846,3855},locked = true,attributes = {owner = nil,buyable = true,price = 20000,value = 16000,doorgroup = "10 Any Way",typ = "appartment"}};
    ["12 Any Way"] = {doors = {2011,2010},locked = true,attributes = {owner = nil,buyable = true,price = 45000,value = 36000,doorgroup = "11 Any Way",typ = "hangar"}};
    ["13 Any Way"] = {doors = {2052,2013,2051},locked = true,attributes = {owner = nil,buyable = true,price = 35000,value = 28000,doorgroup = "12 Any Way",typ = "hangar"}};
    ["hardwarestore"] = {doors = {2049,2571,2570},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "hardwarestore",typ = "shop"}};
    ["gasstation"] = {doors = {2111,2112,2113},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "gasstation",typ = "shop"}};
    ["14 Any Way"] = {doors = {1290,1291,1288,1289,2231,2299},locked = true,attributes = {owner = nil,buyable = true,price = 50000,value = 40000,doorgroup = "14 Any Way",typ = "hangar"}};
    ["club"] = {doors = {2100,2101,3539,3466,3465,3546,3545,3551,3468,3481},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "nightclub",typ = "shop"}};
    ["1 Pleasant Rd"] = {doors = {2699,2698,2700},locked = true,attributes = {owner = nil,buyable = true,price = 62500,value = 50000,doorgroup = "1 Pleasant Rd",typ = "hangar"}};
    ["1 South St"] = {doors = {2025,2026,2027,2170},locked = true,attributes = {owner = nil,buyable = true,price = 725000,value = 58000,doorgroup = "1 South St",typ = "hangar"}};
    ["bank"] = {doors = {3114,3115},locked = true,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "bank",typ = "shop"}};
    ["1 Bank St"] = {doors = {2707,2706,2708},locked = true,attributes = {owner = nil,buyable = true,price = 67500,value = 54000,doorgroup = "1 Bank St",typ = "hangar"}};
    ["6-1 Crooked Ln"] = {doors = {3258},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "6-1 Crooked Ln",typ = "hugetower"}};
    ["6-2 Crooked Ln"] = {doors = {3257},locked = true,attributes = {owner = nil,buyable = true,price = 10000,value = 8000,doorgroup = "6-2 Crooked Ln",typ = "hugetower"}};
    ["8-1 Crooked Ln"] = {doors = {3264},locked = true,attributes = {owner = nil,buyable = true,price = 12500,value = 10000,doorgroup = "8-1 Crooked Ln",typ = "hugetower"}};
    ["8-2 Crooked Ln"] = {doors = {3265},locked = true,attributes = {owner = nil,buyable = true,price = 12500,value = 10000,doorgroup = "8-2 Crooked Ln",typ = "hugetower"}};
    ["10-1 Crooked Ln"] = {doors = {3268},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "10-1 Crooked Ln",typ = "hugetower"}};
    ["10-2 Crooked Ln"] = {doors = {3269},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "10-2 Crooked Ln",typ = "hugetower"}};
    ["12 Crooked Ln"] = {doors = {3298,3305},locked = true,attributes = {owner = nil,buyable = true,price = 17500,value = 14000,doorgroup = "12 Crooked Ln",typ = "hugetower"}};
    ["jewelrystore"] = {doors = {2050,2195,2059},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "jewelry",typ = "shop"}};
    ["A Union Sq"] = {doors = {3135,3137,3136},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "A Union Sq",typ = "appartment"}};
    ["B Union Sq"] = {doors = {3138,3139,3140},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "B Union Sq",typ = "appartment"}};
    ["C Union Sq"] = {doors = {3132,3133,3134},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "C Union Sq",typ = "appartment"}};
    ["D Union Sq"] = {doors = {3130,3131,2956},locked = true,attributes = {owner = nil,buyable = true,price = 15000,value = 12000,doorgroup = "D Union Sq",typ = "appartment"}};
    ["E Union Sq"] = {doors = {3002,3004,3003},locked = true,attributes = {owner = nil,buyable = true,price = 20000,value = 16000,doorgroup = "E Union Sq",typ = "appartment"}};
    ["F Union Sq"] = {doors = {1358,1359,1360},locked = true,attributes = {owner = nil,buyable = true,price = 20000,value = 16000,doorgroup = "F Union Sq",typ = "appartment"}};
    ["G Union Sq"] = {doors = {1353,1354,1355},locked = true,attributes = {owner = nil,buyable = true,price = 20000,value = 16000,doorgroup = "G Union Sq",typ = "appartment"}};
    ["H Union Sq"] = {doors = {1356,2957,1357},locked = true,attributes = {owner = "mafia",buyable = true,price = 20000,value = 16000,doorgroup = "H Union Sq",typ = "appartment"}};
    ["I Union Sq"] = {doors = {2997,3001,3000},locked = true,attributes = {owner = nil,buyable = true,price = 25000,value = 20000,doorgroup = "I Union Sq",typ = "appartment"}};
    ["J Union Sq"] = {doors = {1361,1362,1363},locked = true,attributes = {owner = nil,buyable = true,price = 25000,value = 20000,doorgroup = "J Union Sq",typ = "appartment"}};
    ["K Union Sq"] = {doors = {1364,1366,1365},locked = true,attributes = {owner = nil,buyable = true,price = 25000,value = 20000,doorgroup = "K Union Sq",typ = "appartment"}};
    ["L Union Sq"] = {doors = {1367,2958,1368},locked = true,attributes = {owner = nil,buyable = true,price = 25000,value = 20000,doorgroup = "L Union Sq",typ = "appartment"}};
    ["1 New Life St"] = {doors = {1958,2372,2363},locked = true,attributes = {owner = nil,buyable = true,price = 30000,value = 24000,doorgroup = "1 New Life St",typ = "garage"}};
    ["2 New Life St"] = {doors = {2044,2373,2364},locked = true,attributes = {owner = nil,buyable = true,price = 30000,value = 24000,doorgroup = "2 New Life St",typ = "garage"}};
    ["3 New Life St"] = {doors = {2046,2376,2055},locked = true,attributes = {owner = nil,buyable = true,price = 30000,value = 24000,doorgroup = "3 New Life St",typ = "garage"}};
    ["Mairie open"] = {doors = {3008,3007},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "Mairie open",typ = "garage"}};
    ["Mairie closed"] = {doors = {3018,3019},locked = true,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "Mairie closed",typ = "garage"}};
    ["archivist"] = {doors = {2047,2380,2054},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "archivist",typ = "shop"}};
    ["1 13th St"] = {doors = {1964,1965,1300},locked = true,attributes = {owner = nil,buyable = true,price = 12500,value = 10000,doorgroup = "1 13th St",typ = "appartment"}};
    ["2 13th St"] = {doors = {2259,2260,1296},locked = true,attributes = {owner = nil,buyable = true,price = 12500,value = 10000,doorgroup = "2 13th St",typ = "appartment"}};
    ["3 13th St"] = {doors = {2257,2258,1295},locked = true,attributes = {owner = nil,buyable = true,price = 17500,value = 14000,doorgroup = "3 13th St",typ = "appartment"}};
    ["4 13th St"] = {doors = {1969,1299,1968},locked = true,attributes = {owner = nil,buyable = true,price = 17500,value = 14000,doorgroup = "4 13th St",typ = "appartment"}};
    ["5 13th St"] = {doors = {2256,2255,1293},locked = true,attributes = {owner = nil,buyable = true,price = 22500,value = 18000,doorgroup = "5 13th St",typ = "appartment"}};
    ["6 13th St"] = {doors = {1970,1298,1972},locked = true,attributes = {owner = nil,buyable = true,price = 22500,value = 18000,doorgroup = "6 13th St",typ = "appartment"}};
    ["7 13th St"] = {doors = {1977,1978,1294},locked = true,attributes = {owner = nil,buyable = true,price = 27500,value = 22000,doorgroup = "7 13th St",typ = "appartment"}};
    ["8 13th St"] = {doors = {1971,1297,1973},locked = true,attributes = {owner = nil,buyable = true,price = 27500,value = 22000,doorgroup = "8 13th St",typ = "appartment"}};
    ["9 13th St"] = {doors = {2048,2381,2053},locked = true,attributes = {owner = nil,buyable = true,price = 30000,value = 24000,doorgroup = "1 13th St",typ = "garage"}};
    ["repairgarage"] = {doors = {2060,2062,2066,2061,2067,2065},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "garage",typ = "shop"}};
    ["drugstore"] = {doors = {2166,2582,2167},locked = false,attributes = {owner = nil,buyable = false,price = 10000,value = 8000,doorgroup = "drugstore",typ = "shop"}};
}
gbrp.foods = {
    ["mre"] = {model = "models/crunchy/props/eft_props/mre.mdl", energy = 25, price = 15},
    ["beefstew"] = {model = "models/crunchy/props/eft_props/beefstew.mdl", energy = 17, price = 7},
    ["beefstew_family"] = {model = "models/crunchy/props/eft_props/beefstew2.mdl", energy = 20, price = 10},
    ["canned_fish"] = {model = "models/crunchy/props/eft_props/herring.mdl", energy = 13, price = 3},
    ["peas"] = {model = "models/crunchy/props/eft_props/peas.mdl", energy = 18, price = 8},
    ["squash"] = {model = "models/crunchy/props/eft_props/squash.mdl", energy = 19, price = 9},
    ["hotrod"] = {model = "models/crunchy/props/eft_props/hotrod.mdl", energy = 22, price = 12},
    ["juice"] = {model = "models/crunchy/props/eft_props/juice.mdl", energy = 16, price = 6},
    ["oatmeal"] = {model = "models/crunchy/props/eft_props/oatmeal.mdl", energy = 13, price = 3},
    ["water"] = {model = "models/crunchy/props/eft_props/waterbottle.mdl", energy = 16, price = 6},
    ["hotdog"] = {model = "models/food/hotdog.mdl", energy = 16, price = 6},
}
gbrp.customMapEntities = {
    [2587] = {}
}
gbrp.c_arms = {
    ["models/sentry/sentryoldmob/greaser/sentrygreasemale2pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 2,
                [5] = 2,
                [6] = 2,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 2,
                [3] = 2,
                [4] = 0,
                [5] = 1,
                [6] = 2,
            },
            bgid = 0
        },
        [5] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/greaser/sentrygreasemale4pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 2,
                [5] = 2,
                [6] = 2,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 2,
                [3] = 2,
                [4] = 0,
                [5] = 1,
                [6] = 2,
            },
            bgid = 0
        },
        [5] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/greaser/sentrygreasemale7pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 2,
                [5] = 2,
                [6] = 2,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 2,
                [3] = 2,
                [4] = 0,
                [5] = 1,
                [6] = 2,
            },
            bgid = 0
        },
        [5] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/greaser/sentrygreasemale9pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 2,
                [5] = 2,
                [6] = 2,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 2,
                [3] = 2,
                [4] = 0,
                [5] = 1,
                [6] = 2,
            },
            bgid = 0
        },
        [5] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/mafia/sentrymobmale2pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 0,
                [7] = 0,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 0,
                [4] = 1,
                [5] = 2,
                [6] = 4,
                [7] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/mafia/sentrymobmale4pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 0,
                [7] = 0,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 0,
                [4] = 1,
                [5] = 2,
                [6] = 4,
                [7] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/mafia/sentrymobmale6pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 0,
                [7] = 0,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 0,
                [4] = 1,
                [5] = 2,
                [6] = 4,
                [7] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/mafia/sentrymobmale7pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 0,
                [7] = 0,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 0,
                [4] = 1,
                [5] = 2,
                [6] = 4,
                [7] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/mafia/sentrymobmale8pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 0,
                [7] = 0,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 0,
                [4] = 1,
                [5] = 2,
                [6] = 4,
                [7] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/mafia/sentrymobmale9pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 0,
                [7] = 0,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 0,
                [4] = 1,
                [5] = 2,
                [6] = 4,
                [7] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/irish/sentryirishmale2pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 1,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 3,
                [4] = 0,
                [5] = 1,
                [6] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/irish/sentryirishmale4pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 1,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 3,
                [4] = 0,
                [5] = 1,
                [6] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/irish/sentryirishmale6pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 1,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 3,
                [4] = 0,
                [5] = 1,
                [6] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/irish/sentryirishmale7pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 1,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 3,
                [4] = 0,
                [5] = 1,
                [6] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/irish/sentryirishmale8pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 1,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 3,
                [4] = 0,
                [5] = 1,
                [6] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/irish/sentryirishmale9pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 1,
            },
            skins = {
                [0] = 0,
                [1] = 1,
                [2] = 3,
                [3] = 3,
                [4] = 0,
                [5] = 1,
                [6] = 2,
            },
            bgid = 0
        },
        [6] = {
            bodygroups = {
                [0] = 0,
                [1] = 1,
            },
            bgid = 1
        }
    },
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male2pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 0,
            },
            skins = {
                [0] = 3,
                [1] = 0,
                [2] = 1,
                [3] = 2,
            },
            bgid = 0
        }
    },
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male4pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 0,
            },
            skins = {
                [0] = 3,
                [1] = 0,
                [2] = 1,
                [3] = 2,
            },
            bgid = 0
        }
    },
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male6pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 0,
            },
            skins = {
                [0] = 3,
                [1] = 0,
                [2] = 1,
                [3] = 2,
            },
            bgid = 0
        }
    },
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male7pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 0,
            },
            skins = {
                [0] = 3,
                [1] = 0,
                [2] = 1,
                [3] = 2,
            },
            bgid = 0
        }
    },
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 0,
            },
            skins = {
                [0] = 3,
                [1] = 0,
                [2] = 1,
                [3] = 2,
            },
            bgid = 0
        }
    },
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male9pm.mdl"] = {
        [2] = {
            bodygroups = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 0,
            },
            skins = {
                [0] = 3,
                [1] = 0,
                [2] = 1,
                [3] = 2,
            },
            bgid = 0
        }
    },
}
gbrp.dealerpos = {
    [1] = {pos = Vector(-3820.632324,4315.528320,-38.120117), ang = Angle(0,-90,0)},
    [2] = {pos = Vector(213.825684,7069.883789,121.879883), ang = Angle(0,-98.743011,0)},
    [3] = {pos = Vector(1712.468628,8209.974609,177.879883), ang = Angle(0,-4.939997,0)},
    [4] = {pos = Vector(4188.500977,6394.341309,81.879883), ang = Angle(0,-89.734322,0)},
    [5] = {pos = Vector(3489.109375,8379.791016,201.879883), ang = Angle(0,1.426012,0)},
    [6] = {pos = Vector(4707.984863,2009.082153,-38.120117), ang = Angle(0,-177.882141,0)},
    [7] = {pos = Vector(4391.191406,52.472580,-34.019478), ang = Angle(0,-168.272705,0)},
    [8] = {pos = Vector(-9388.332031,1625.529785,65.879883), ang = Angle(0,87.816544,0)},
    [9] = {pos = Vector(-4814.350586,-3661.320068,-271.446075), ang = Angle(0,38.823296,0)}
}
gbrp.vanpos = {
    [1] = {pos = Vector(1553,10469,194), ang = Angle(0,-90,0)},
    [2] = {pos = Vector(-12415,10086,314), ang = Angle(0,0,0)},
    [3] = {pos = Vector(5899,-3527,-110), ang = Angle(0,180,0)}
}
gbrp.promotion = {
    ["vip"] = {
        ["user"] = "VIP",
        ["VIP"] = "VIP",
        ["VIP+"] = "VIP+",
        ["moderateur"] = "moderateur_vip",
        ["moderateur_vip"] = "moderateur_vip",
        ["moderateur_vip+"] = "moderateur_vip",
        ["moderateur_test"] = "moderateur_test_vip",
        ["moderateur_test_vip"] = "moderateur_test_vip",
        ["moderateur_test_vip+"] = "moderateur_test_vip",
        ["admin"] = "admin",
        ["superadmin"] = "superadmin",
    },
    ["vip+"] = {
        ["user"] = "VIP+",
        ["VIP"] = "VIP+",
        ["VIP+"] = "VIP+",
        ["moderateur"] = "moderateur_vip+",
        ["moderateur_vip"] = "moderateur_vip+",
        ["moderateur_vip+"] = "moderateur_vip+",
        ["moderateur_test"] = "moderateur_test_vip+",
        ["moderateur_test_vip"] = "moderateur_test_vip+",
        ["moderateur_test_vip+"] = "moderateur_test_vip+",
        ["admin"] = "admin",
        ["superadmin"] = "superadmin",
    }
}
gbrp.demotion = {
    ["user"] = "user",
    ["VIP"] = "user",
    ["VIP+"] = "user",
    ["moderateur"] = "moderateur",
    ["moderateur_vip"] = "moderateur",
    ["moderateur_vip+"] = "moderateur",
    ["moderateur_test"] = "moderateur_test",
    ["moderateur_test_vip"] = "moderateur_test",
    ["moderateur_test_vip+"] = "moderateur_test",
    ["admin"] = "admin",
    ["superadmin"] = "superadmin"
}
function gbrp.formatMoney(n)
    if not n then return "$0" end

    if n >= 1e14 then return "$" .. tostring(n) end
    if n <= -1e14 then return "-" .. "$" .. tostring(math.abs(n)) end

    local negative = n < 0

    n = tostring(math.abs(n))
    local dp = string.find(n, "%.") or #n + 1

    for i = dp - 4, 1, -3 do
        n = n:sub(1, i) .. "." .. n:sub(i + 1)
    end

    -- Make sure the amount is padded with zeroes
    if n[#n - 1] == "." then
        n = n .. "0"
    end

    return (negative and "-" or "") .. "$" .. n
end
function gbrp.sortedGangs()
    for _,ply in pairs(player.GetAll()) do
        local gang = ply:GetGang()
        if gang then gang.ct = gang.ct + 1 end
    end
    local gangs = table.Copy(gbrp.gangs)
    local max = "yakuzas"
    for k,v in pairs(gangs) do
        if v.ct > gangs[max].ct then
            max = k
        end
    end
    gangs[max] = nil
    return gangs
end
function gbrp.GetPropertyTax()
    return GetGlobalInt("propertyTax")
end
function gbrp.GetHousingTax()
    return GetGlobalInt("housingTax")
end
function gbrp.GetIncomeTax()
    return GetGlobalInt("incomeTax")
end
function gbrp.GetVAT()
    return GetGlobalInt("VAT")
end
gbrp.gang = {}
function gbrp.gang:GetMembersCount()
    local count = 0
    for _,ply in pairs(player.GetAll()) do
        if ply:GetGang() == self then count = count + 1 end
    end
    return count
end
function gbrp.gang:GetShopNames()
    local shops = {}
    for _,ent in pairs(ents.GetAll()) do
        if ent:GetClass() == "gbrp_shop" and ent:GetGang() == self then table.insert(shops,ent:GetShopName()) end
    end
    return shops
end
function gbrp.gang:GetShops()
    local shops = {}
    for _,ent in pairs(ents.GetAll()) do
        if ent:GetClass() == "gbrp_shop" and ent:GetGang() == self then table.insert(shops,ent) end
    end
    return shops
end
function gbrp.gang:GetHousesTypes()
    local houses = {}
    for k,v in pairs(gbrp.doors) do
        local door = ents.GetByIndex(k)
        if door:getDoorData().groupOwn == self.name and gbrp.doors[k].typ ~= "shop" then
            houses[gbrp.doors[k].doorgroup] = gbrp.doors[k].typ
        end
    end
    return houses
end
function gbrp.gang:GetHouses()
    local houses = {}
    for k,v in pairs(gbrp.doors) do
        local door = ents.GetByIndex(k)
        if door:getDoorData().groupOwn == self.name and gbrp.doors[k].typ ~= "shop" then
            houses[gbrp.doors[k].doorgroup] = gbrp.doors[k]
        end
    end
    return houses
end
function gbrp.gang:GetBalance()
    return GetGlobalInt(self.name .. "Balance")
end
function gbrp.gang:GetExpenses()
    return GetGlobalInt(self.name .. "Expenses")
end
function gbrp.gang:GetIncomes()
    return GetGlobalInt(self.name .. "Incomes")
end
function gbrp.gang:CanAfford(amount)
    return self:GetBalance() - amount >= 0
end
function gbrp.gang:GetPrivateDoorsCount()
    return GetGlobalInt(self.name .. "PrivateDoorsCount")
end
function gbrp.gang:GetLeader()
    local _,teamid = DarkRP.getJobByCommand(self.leaderCommand)
    return team.GetPlayers(teamid)[1]
end
if SERVER then
    gbrp.hardwarestore = {
        spawnPos = Vector(1303,-1529,-50),
        items = {
            ["lockpick"] = {model = "models/weapons/w_crowbar.mdl", price = 15},
            ["weapon_spraymhs"] = {model = "models/weapons/w_crowbar.mdl", price = 7},
            ["weapon_slam"] = {model = "models/weapons/w_slam.mdl", price = 10},
            ["weapon_rope_knife"] = {model = "models/weapons/hl2meleepack/w_hook.mdl", price = 3},
            ["weapon_handcuffs"] = {model = "models/katharsmodels/handcuffs/handcuffs-1.mdl", price = 8},
            ["weapon_breachingcharge"] = {model = "models/minic23/csgo/breach_charge.mdl", price = 9},
            ["wep_jack_job_drpradio"] = {model = "models/radio/w_radio.mdl", price = 12},
        }
    }
    function gbrp.SpawnNPCs()
        local bank1 = ents.Create("gbrp_bank_receptionist")
        bank1.gender = "female"
        bank1:SetModel("models/humans/group10/female_01.mdl")
        bank1:SetPos(Vector(-954,2812,-38))
        bank1:SetAngles(Angle(0,-90,0))
        bank1:Spawn()

        local bank2 = ents.Create("gbrp_bank_receptionist")
        bank2.gender = "female"
        bank2:SetModel("models/humans/group10/female_04.mdl")
        bank2:SetPos(Vector(-1063,2812,-38))
        bank2:SetAngles(Angle(0,-90,0))
        bank2:Spawn()

        local bank3 = ents.Create("gbrp_bank_receptionist")
        bank3.gender = "male"
        bank3:SetModel("models/humans/group10/male_02.mdl")
        bank3:SetPos(Vector(-1159,2812,-38))
        bank3:SetAngles(Angle(0,-90,0))
        bank3:Spawn()

        local jewelry = ents.Create("gbrp_shop")
        jewelry:SetModel("models/humans/group10/male_04.mdl")
        jewelry:SetPos(Vector(-576.345520,253.843369,-30.031754))
        jewelry:SetAngles(Angle(0,0,0))
        jewelry:SetShopName("jewelrystore")
        jewelry:SetPrice(850000)
        jewelry:SetValue(650992)
        jewelry:Spawn()
        jewelry.niceName = "Bijouterie"

        local hardwarestore = ents.Create("gbrp_shop")
        hardwarestore:SetModel("models/1000shells/player/worker/npc/worker_npc.mdl")
        hardwarestore:SetPos(Vector(1298.557983,-1579.187866,-29.987122))
        hardwarestore:SetAngles(Angle(0,90,0))
        hardwarestore:SetShopName("hardwarestore")
        hardwarestore:SetPrice(320000)
        hardwarestore:SetValue(160111)
        hardwarestore:Spawn()
        hardwarestore.niceName = "Quincaillerie"

        local gunshop = ents.Create("gbrp_shop")
        gunshop:SetModel("models/player/spike/josef.mdl")
        gunshop:SetPos(Vector(-1099.968750,10497.299805,202.012878))
        gunshop:SetAngles(Angle(0,-180,0))
        gunshop:SetShopName("gunshop")
        gunshop:SetPrice(712000)
        gunshop:SetValue(519194)
        gunshop:Spawn()
        gunshop.niceName = "Armurerie"

        local drugstore = ents.Create("gbrp_shop")
        drugstore:SetModel("models/Kleiner.mdl")
        drugstore:SetPos(Vector(-6566.270508,3409.478027,42.012878))
        drugstore:SetAngles(Angle(0,-90,0))
        drugstore:SetShopName("drugstore")
        drugstore:SetPrice(300000)
        drugstore:SetValue(151527)
        drugstore:Spawn()
        drugstore.niceName = "Pharmacie"

        local club = ents.Create("gbrp_shop")
        club:SetModel("models/alyx.mdl")
        club:SetPos(Vector(-7678.176758,5545.522461,66.012878))
        club:SetAngles(Angle(0,90,0))
        club:SetShopName("club")
        club:SetPrice(625000)
        club:SetValue(458498)
        club:Spawn()
        club.niceName = "Boite de nuit"

        local repairgarage = ents.Create("gbrp_shop")
        repairgarage:SetModel("models/odessa.mdl")
        repairgarage:SetPos(Vector(-2378.206543,6402.301758,90.012878))
        repairgarage:SetAngles(Angle(0,-5.253576,0))
        repairgarage:SetShopName("repairgarage")
        repairgarage:SetPrice(200000)
        repairgarage:SetValue(98812)
        repairgarage:Spawn()
        repairgarage.niceName = "Garage"

        local bar = ents.Create("gbrp_shop")
        bar:SetModel("models/player/spike/nigel.mdl")
        bar:SetPos(Vector(4955,8042,210))
        bar:SetAngles(Angle(0,0,0))
        bar:SetShopName("bar")
        bar:SetPrice(100000)
        bar:SetValue(100000)
        bar:Spawn()
        bar.niceName = "Bar"

        local gasstation = ents.Create("gbrp_shop")
        gasstation:SetModel("models/eli.mdl")
        gasstation:SetPos(Vector(-5872,1543,50))
        gasstation:SetAngles(Angle(0,-90,0))
        gasstation:SetShopName("gasstation")
        gasstation:SetPrice(245000)
        gasstation:SetValue(135887)
        gasstation:Spawn()
        gasstation.niceName = "Station service"

        local meth = ents.Create("eml_buyer")
        meth:SetPos(Vector(2020,6699,-290))
        meth:SetAngles(Angle(0,180,0))
        meth:Spawn()

        local cocaine = ents.Create("cocaine_drugs_buyer")
        cocaine:SetPos(Vector(990,1648,-430))
        cocaine:SetAngles(Angle(0,90,0))
        cocaine:Spawn()

        local mayor = ents.Create("gbrp_mayor")
        mayor:SetPos(Vector(2502.454102,5055.062500,65.969872))
        mayor:SetAngles(Angle(2.425522,0.616063,0))
        mayor:Spawn()

        local randint = math.random(1,#gbrp.dealerpos)
        gbrp.dealerpos[randint].posTaken = true
        meth1 = ents.Create("eml_buyer")
        meth1:SetPos(gbrp.dealerpos[randint].pos)
        meth1:SetAngles(gbrp.dealerpos[randint].ang)
        meth1:Spawn()

        while gbrp.dealerpos[randint].posTaken == true do
            randint = math.random(1,#gbrp.dealerpos)
        end
        gbrp.dealerpos[randint].posTaken = true
        cocaine1 = ents.Create("cocaine_drugs_buyer")
        cocaine1:SetPos(gbrp.dealerpos[randint].pos)
        cocaine1:SetAngles(gbrp.dealerpos[randint].ang)
        cocaine1:Spawn()

        while gbrp.dealerpos[randint].posTaken == true do
            randint = math.random(1,#gbrp.dealerpos)
        end
        gbrp.dealerpos[randint].posTaken = true
        gundealer = ents.Create("npc_gundealer")
        gundealer:SetPos(gbrp.dealerpos[randint].pos)
        gundealer:SetAngles(gbrp.dealerpos[randint].ang)
        gundealer:Spawn()

        while gbrp.dealerpos[randint].posTaken == true do
            randint = math.random(1,#gbrp.dealerpos)
        end
        gbrp.dealerpos[randint].posTaken = true
        launderer = ents.Create("gbrp_launderer")
        launderer:SetPos(gbrp.dealerpos[randint].pos)
        launderer:SetAngles(gbrp.dealerpos[randint].ang)
        launderer:Spawn()

        local random = gbrp.vanpos[math.random(1,#gbrp.vanpos)]
        cf_export_van = ents.Create("cf_export_van")
        cf_export_van:SetPos(random.pos)
        cf_export_van:SetAngles(random.ang)
        cf_export_van:Spawn()
    end
    function gbrp.SpawnHotdogSalesmans()
        local salesman1 = ents.Create("gbrp_hotdogsalesman")
        salesman1.hotdogpos = Vector(1985.312012,5540.983398,46.440498)
        salesman1:SetPos(Vector(1953.749268,5490.832520,8.031250))
        salesman1:SetAngles(Angle(0,90,0))
        salesman1:Spawn()

        local salesman2 = ents.Create("gbrp_hotdogsalesman")
        salesman2.hotdogpos = Vector(3762.856201,5870.750000,46.440498)
        salesman2:SetPos(Vector(3740.848389,5814.738281,8.031242))
        salesman2:SetAngles(Angle(0,90,0))
        salesman2:Spawn()

        local salesman3 = ents.Create("gbrp_hotdogsalesman")
        salesman3.hotdogpos = Vector(5800.159668,4402.841309,-17.559513)
        salesman3:SetPos(Vector(5840.312500,4459.221191,-55.968750))
        salesman3:SetAngles(Angle(0,-90,0))
        salesman3:Spawn()

        local salesman4 = ents.Create("gbrp_hotdogsalesman")
        salesman4.hotdogpos = Vector(-6306.340332,2667.020508,-7)
        salesman4:SetPos(Vector(-6298.107910,2717.878174,-40))
        salesman4:SetAngles(Angle(0,-90,0))
        salesman4:Spawn()

        local salesman5 = ents.Create("gbrp_hotdogsalesman")
        salesman5.hotdogpos = Vector(5211.087402,8753.347656,166.440491)
        salesman5:SetPos(Vector(5186.979492,8707.676758,128))
        salesman5:SetAngles(Angle(0,90,0))
        salesman5:Spawn()

        local salesman6 = ents.Create("gbrp_hotdogsalesman")
        salesman6.hotdogpos = Vector(6286.805664,888.787598,-65.55950)
        salesman6:SetPos(Vector(6341.223145,865.494080,-103))
        salesman6:SetAngles(Angle(0,180,0))
        salesman6:Spawn()

        local salesman7 = ents.Create("gbrp_hotdogsalesman")
        salesman7.hotdogpos = Vector(1560.791504,340.471008,-65.559509)
        salesman7:SetPos(Vector(1601,323,-104))
        salesman7:SetAngles(Angle(0,180,0))
        salesman7:Spawn()

        local salesman8 = ents.Create("gbrp_hotdogsalesman")
        salesman8.hotdogpos = Vector(-2793.504395,11675.882813,166.44)
        salesman8:SetPos(Vector(-2749,11658,130))
        salesman8:SetAngles(Angle(0,180,0))
        salesman8:Spawn()
    end
    function gbrp.RemoveHotdogSalesmans()
        for _,npc in pairs(ents.FindByClass("gbrp_hotdogsalesman")) do
            npc:Remove()
        end
    end
    function gbrp.InitDoors()
        gbrp.doors = {}
        local counter = 0
        for doorgroupname,doorgroup in pairs(gbrp.doorgroups) do
            for _,doormapid in pairs(doorgroup.doors) do
                counter = counter + 1
                local door = ents.GetMapCreatedEntity(doormapid)
                if not IsValid(door) then print("[GBRP] This door is causing problems" .. tostring(doormapid)) break end
                door:setDoorGroup(doorgroup.attributes.owner)
                if doorgroup.locked then
                    door:Fire("lock", "", 0)
                end
                gbrp.doors[door:EntIndex()] = doorgroup.attributes
            end
        end
    end
    function gbrp.SendDoorsData(ply)
        net.Start("GBRP::doorsinit")
        net.WriteInt(table.Count(gbrp.doors),32)
        for k,v in pairs(gbrp.doors) do
            net.WriteInt(k,32)
            net.WriteTable(v)
        end
        net.Send(ply)
    end
    function gbrp.SaveDoors()
        gbrp.savedDoors = {}
        for doorgroupname,doorgroup in pairs(gbrp.doorgroups) do
            for _,doormapid in pairs(doorgroup.doors) do
                local door = ents.GetMapCreatedEntity(doormapid)
                if not table.IsEmpty(door:getDoorData()) then
                    gbrp.savedDoors[doormapid] = {}
                    gbrp.savedDoors[doormapid].darkrpvars = door:getDoorData()
                    gbrp.savedDoors[doormapid].locked = door:GetInternalVariable("m_bLocked")
                end
            end
        end
    end
    function gbrp.LoadDoors()
        for doormapid,tab in pairs(gbrp.savedDoors) do
            local door = ents.GetMapCreatedEntity(doormapid)
            door:setDoorGroup(tab.darkrpvars.groupOwn)
            if tab.darkrpvars.owner then
                door:keysOwn(tab.darkrpvars.owner)
            end
            if tab.locked then
                door:Fire("Lock", "", 0)
            else
                door:Fire("Unlock", "", 0)
            end
        end
    end
    function gbrp.SaveShops()
        gbrp.savedShops = {}
        for _,ent in pairs(ents.FindByClass("gbrp_shop")) do
            gbrp.savedShops[ent:GetShopName()] = {}
            gbrp.savedShops[ent:GetShopName()].balance = ent:GetBalance()
            gbrp.savedShops[ent:GetShopName()].dirtyMoney = ent:GetDirtyMoney()
            gbrp.savedShops[ent:GetShopName()].gangName = ent:GetGangName()
        end
    end
    function gbrp.LoadShops()
        for _,ent in pairs(ents.FindByClass("gbrp_shop")) do
            for name,val in pairs(gbrp.savedShops) do
                if name == ent:GetShopName() then
                    ent:SetBalance(val.balance)
                    ent:SetDirtyMoney(val.dirtyMoney)
                    ent:SetGangName(val.gangName)
                end
            end
        end
    end
    function gbrp.MoveNPCs()
        for k,v in pairs(gbrp.dealerpos) do
            v.posTaken = false
        end
        local randint = math.random(1,#gbrp.dealerpos)
        gbrp.dealerpos[randint].posTaken = true
        meth1:SetPos(gbrp.dealerpos[randint].pos)
        meth1:SetAngles(gbrp.dealerpos[randint].ang)
        meth1:DropToFloor()

        while gbrp.dealerpos[randint].posTaken == true do
            randint = math.random(1,#gbrp.dealerpos)
        end
        gbrp.dealerpos[randint].posTaken = true
        cocaine1:SetPos(gbrp.dealerpos[randint].pos)
        cocaine1:SetAngles(gbrp.dealerpos[randint].ang)

        while gbrp.dealerpos[randint].posTaken == true do
            randint = math.random(1,#gbrp.dealerpos)
        end
        gbrp.dealerpos[randint].posTaken = true
        gundealer:SetPos(gbrp.dealerpos[randint].pos)
        gundealer:SetAngles(gbrp.dealerpos[randint].ang)
        gundealer:DropToFloor()

        while gbrp.dealerpos[randint].posTaken == true do
            randint = math.random(1,#gbrp.dealerpos)
        end
        gbrp.dealerpos[randint].posTaken = true
        launderer:SetPos(gbrp.dealerpos[randint].pos)
        launderer:SetAngles(gbrp.dealerpos[randint].ang)
        launderer:DropToFloor()

        local random = gbrp.vanpos[math.random(1,#gbrp.vanpos)]
        cf_export_van:SetPos(random.pos)
        cf_export_van:SetAngles(random.ang)
        cf_export_van:DropToFloor()
    end
    function gbrp.gang:AddIncomes(amount)
        SetGlobalInt(self.name .. "Incomes",self:GetIncomes() + amount)
    end
    function gbrp.gang:AddExpenses(amount)
        SetGlobalInt(self.name .. "Expenses",self:GetExpenses() + amount)
    end
    function gbrp.gang:SetBalance(val)
        SetGlobalInt(self.name .. "Balance",val)
    end
    function gbrp.gang:Cash(amount)
        self:SetBalance(self:GetBalance() + amount)
        self:AddIncomes(amount)
    end
    function gbrp.gang:Pay(amount)
        if self:GetBalance() - amount >= 0 then
            self:SetBalance(self:GetBalance() - amount)
            self:AddExpenses(amount)
        else
            self:AddExpenses(self:GetBalance())
            self:SetBalance(0)
        end
    end
    function gbrp.gang:Reset()
        for k,v in pairs(gbrp.doors) do
            local door = ents.GetByIndex(k)
            if door:getDoorData().groupOwn == self.name and gbrp.doorgroups[gbrp.doors[k].doorgroup].attributes.owner ~= self.name then
                for _,doorid in pairs(gbrp.doorgroups[gbrp.doors[k].doorgroup].doors) do
                    door = ents.GetMapCreatedEntity(doorid)
                    door:setDoorGroup(nil)
                    if door:getDoorOwner() then
                        door:keysUnOwn(door:getDoorOwner())
                        self:AddPrivateDoor(-1)
                    end
                    door:Fire("lock", "", 0)
                end
            end
        end
        local shops = ents.FindByClass("gbrp_shop")
        for i,shop in pairs(shops) do
            if shop:GetGang() == self then
                shop:SetGang(nil)
            end
        end
    end
    function gbrp.gang:SetPrivateDoorsCount(count)
        return SetGlobalInt(self.name .. "PrivateDoorsCount",count)
    end
    function gbrp.gang:AddPrivateDoor(amount)
        self:SetPrivateDoorsCount(self:GetPrivateDoorsCount() + amount)
    end
end
if CLIENT then
    gbrp.hardwarestore = {
        crowbar = Material("gui/gbrp/hardwarestore/crowbar.png"),
        peinture = Material("gui/gbrp/hardwarestore/peinture.png"),
        slam = Material("gui/gbrp/hardwarestore/slam.png"),
        hookMat = Material("gui/gbrp/hardwarestore/hook.png"),
        handscuffs = Material("gui/gbrp/hardwarestore/handscuffs.png"),
        c4 = Material("gui/gbrp/hardwarestore/c4.png"),
        walkieTalkie = Material("gui/gbrp/hardwarestore/walkie-talkie.png"),
        trace = Material("gui/gbrp/hardwarestore/trace.png"),
        items = {
            [1] = {name = "lockpick", price = 15, y = 393},
            [2] = {name = "weapon_spraymhs", price = 7, y = 435},
            [3] = {name = "weapon_slam", price = 10, y = 476},
            [4] = {name = "weapon_rope_knife", price = 3, y = 516},
            [5] = {name = "weapon_handcuffs", price = 8, y = 551},
            [6] = {name = "weapon_breachingcharge", price = 9, y = 590},
            [7] = {name = "wep_jack_job_drpradio", price = 12, y = 643},
        }
    }
    gbrp.gangpanel = {}
    gbrp.gangpanel.properties = {
        ["house"] = {mat = Material("gui/gbrp/gangpanel/house.png"),x = 12,y = 30},
        ["appartment"] = {mat = Material("gui/gbrp/gangpanel/appartment.png"),x = 10,y = 14},
        ["hangar"] = {mat = Material("gui/gbrp/gangpanel/hangar.png"),x = 7,y = 10},
        ["hugetower"] = {mat = Material("gui/gbrp/gangpanel/hugetower.png"),x = 18,y = 11},
        ["garage"] = {mat = Material("gui/gbrp/gangpanel/garage.png"),x = 5,y = 29},
    }
    gbrp.gangpanel.shops = {
        ["gasstation"] = {mat = Material("gui/gbrp/gangpanel/gasstation.png"),x = 10,y = 10},
        ["hardwarestore"] = {mat = Material("gui/gbrp/gangpanel/saw.png"),x = 15,y = 5},
        ["jewelrystore"] = {mat = Material("gui/gbrp/gangpanel/diamond.png"),x = 5,y = 9},
        ["repairgarage"] = {mat = Material("gui/gbrp/gangpanel/tire.png"),x = 6,y = 7},
        ["drugstore"] = {mat = Material("gui/gbrp/gangpanel/drugstore.png"),x = 8,y = 10},
        ["bar"] = {mat = Material("gui/gbrp/gangpanel/beer.png"),x = 15,y = 7},
        ["club"] = {mat = Material("gui/gbrp/gangpanel/cocktail.png"),x = 7,y = 7},
        ["gunshop"] = {mat = Material("gui/gbrp/gangpanel/gun.png"),x = 7,y = 17},
    }
    gbrp.voices = {
        female = {
            "npc/female_speech_1.wav",
            "npc/female_speech_2.wav"
        };
        male = {
            "npc/male_speech_1.wav"
        };
    }
    gbrp.woundedMat = Material("gui/gbrp/wounded.png")
    gbrp.ScreenW = ScrW()
    gbrp.ScreenH = ScrH()
    gbrp.FormatX = function(x)
        return x * gbrp.ScreenW / 1920
    end
    gbrp.FormatY = function(y)
        return y * gbrp.ScreenH / 1080
    end
    gbrp.FormatNumber = function(n)
        n = tostring(n)
        if #n < 3 then
            return n
        elseif #n <= 6 then
            return string.Left(n,#n - 3) .. "k"
        elseif #n <= 9 then
            return string.Left(n,#n - 6) .. "M"
        else
            return string.Left(n,#n - 9) .. "Mds"
        end
    end
    gbrp.FormatXY = function(x,y)
        return gbrp.FormatX(x),gbrp.FormatY(y)
    end
    gbrp.FormatXYWH = function(x,y,w,h)
        return gbrp.FormatX(x),gbrp.FormatY(y),gbrp.FormatX(w),gbrp.FormatY(h)
    end
end
gbrp.gangs = {
    yakuzas = {
        subject = "Les yakuzas",
        name = "yakuzas",
        ct = 0,
        membername = "Yakuza",
        leaderCommand = "yakuleader",
        materials = {
            member = Material("gui/gbrp/welcomescreen/page3/yaku.png"),
            leader = Material("gui/gbrp/welcomescreen/page3/yakuleader.png"),
            archi = Material("gui/gbrp/welcomescreen/page3/yakuarchi.png"),
            medic = Material("gui/gbrp/welcomescreen/page3/yakumedic.png")
        }
    },
    mafia = {
        subject = "La Mafia",
        name = "mafia",
        ct = 0,
        membername = "Mafieux",
        leaderCommand = "mafialeader",
        materials = {
            member = Material("gui/gbrp/welcomescreen/page3/mafia.png"),
            leader = Material("gui/gbrp/welcomescreen/page3/mafialeader.png"),
            archi = Material("gui/gbrp/welcomescreen/page3/mafiaarchi.png"),
            medic = Material("gui/gbrp/welcomescreen/page3/mafiamedic.png")
        }
    },
    gang = {
        subject = "Les gangsters",
        name = "gang",
        ct = 0,
        membername = "Gangster",
        leaderCommand = "gangleader",
        materials = {
            member = Material("gui/gbrp/welcomescreen/page3/gang.png"),
            leader = Material("gui/gbrp/welcomescreen/page3/gangleader.png"),
            archi = Material("gui/gbrp/welcomescreen/page3/gangarchi.png"),
            medic = Material("gui/gbrp/welcomescreen/page3/gangmedic.png")
        }
    }
}
for k,v in pairs(gbrp.gangs) do
    table.Merge(v,gbrp.gang)
end