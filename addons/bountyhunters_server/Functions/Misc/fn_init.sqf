diag_log "======================================================";
diag_log "server init started...";
diag_log "======================================================";

varTower = (nearestObjects [[9635.35,3309.95,15], ["house"], 5]) select 0;
publicVariable "varTower";

onPlayerDisconnected sync_fnc_saveGear;
