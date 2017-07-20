class DefaultEventhandlers;

class CfgPatches
{
    class bountyhunters_server
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"A3_Data_F","A3_Soft_F","A3_Soft_F_Offroad_01","A3_Characters_F"};
        fileName = "bountyhunters_server.pbo";
        author = "JohnDev";
    };
};

class CfgFunctions
{
    class Sync_Functions
    {
        tag = "sync";
        class Sync
        {
            file = "\bountyhunters_server\Functions\Sync";
            class variable {};
            class getOwnerObject {};
            class getDefaultValue {};
            class hint {};
            class saveGear {};
        };
    };
    class Payment_Functions
    {
        tag = "payment";
        class Payment
        {
            file = "\bountyhunters_server\Functions\Payment";
            class carShop {};
            class gunShop {};
        };
    };
    class Farming_Functions
    {
        tag = "farming";
        class Farming
        {
            file = "\bountyhunters_server\Functions\Farming";
            class updatePlant {};
            class harvestPlant {};
            class addVirtualItem {};
            class processing {};
        };
    };
    class Misc_Functions
    {
        tag = "misc";
        class Misc
        {
            file = "\bountyhunters_server\Functions\Misc";
            class init {};
            class findItem {};
            class getPlayerTotalWeigth {};
            class getPlayerItems {};
        };
    };
    class Stats
    {
        tag = "stats";
        class Add
        {
            file = "\bountyhunters_server\Functions\Stats\Add";
            class addCash {};
            class addVirtualItems {};
        };
        class Get
        {
            file = "\bountyhunters_server\Functions\Stats\Get";
            class getCash {};
            class getVirtualItems {};
        };
        class Remove
        {
            file = "\bountyhunters_server\Functions\Stats\Remove";
            class removeCash {};
            class removeVirtualItems {};
        };
        class Set
        {
            file = "\bountyhunters_server\Functions\Stats\Set";
            class setCash {};
            class setVirtualItems {};
        };
    };
    class ServerEventHandler
    {
        tag = "serverevent";
        class ServerEvent
        {
            file = "\bountyhunters_server\Functions\ServerEventHandler";
            class onPlayerDisconnected {};
            class onServerLoop {};
        };
    };
    class ServerLoop
    {
        tag = "serverloop";
        class ServerLoop
        {
            file = "\bountyhunters_server\Functions\ServerLoop";
            class syncServerTime {};
        };
    };
};
