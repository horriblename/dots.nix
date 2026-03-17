{
  services = {
    endlessh = {
      enable = true;
      port = 22;
      openFirewall = true;
    };

    openssh = {
      ports = [14122];
    };
  };
}
