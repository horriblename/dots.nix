{
  services.ddclient = {
    enable = true;
    use = "web";
    passwordFile = "/etc/ddclient/password";
    extraConfig = ''
      use=web, web=dynamicdns.park-your-domain.com/getip
      protocol=namecheap
      server=dynamicdns.park-your-domain.com
      login=pych.xyz
      @
    '';
  };
}
