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
        };
    };
};
