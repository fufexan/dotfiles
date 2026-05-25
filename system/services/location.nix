{
  # enable location service
  location.provider = "geoclue2";

  # provide location
  services.geoclue2 = {
    enable = true;
    geoProviderUrl = "https://beacondb.net/v1/geolocate";
    submissionUrl = "https://beacondb.net/v2/geosubmit";
    submissionNick = "geoclue";

    appConfig = {
      darkman = {
        isAllowed = true;
        isSystem = false;
      };
      gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };
}
