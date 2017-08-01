[] spawn {
    {
        hintSilent (configName _x);
        playSound (configName _x);
        _sound = ASLToAGL [0,0,0] nearestObject "#soundonvehicle";
    	waitUntil {isNull _sound};
    } forEach ("true" configClasses (configFile >> "CfgSounds"));
};
