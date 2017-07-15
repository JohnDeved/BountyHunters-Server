diag_log "======================================================";
diag_log "server init started...";
diag_log "======================================================";

varTower = [9635.35,3309.95,15] nearestObject 224112;
publicVariable "varTower";

onPlayerDisconnected sync_fnc_saveGear;
