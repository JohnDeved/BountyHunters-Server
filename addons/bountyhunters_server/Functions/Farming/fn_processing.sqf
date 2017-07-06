params ["_processorObj"];

_clientOwnerId = remoteExecutedOwner;
_clientObject = [_clientOwnerId]call sync_fnc_getOwnerObject;

_processorType = _processorObj getVariable "processor";
