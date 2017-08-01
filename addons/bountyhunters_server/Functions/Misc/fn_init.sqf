diag_log "======================================================";
diag_log "server init started...";
diag_log "======================================================";
varTower = [9635.35,3309.95,15] nearestObject 224112;
publicVariable "varTower";

serverStart = "real_date" callExtension "0";
publicVariable "serverStart";

onPlayerConnected serverevent_fnc_onPlayerConnected;
onPlayerDisconnected serverevent_fnc_onPlayerDisconnected;

while {true} do serverevent_fnc_onServerLoop;
