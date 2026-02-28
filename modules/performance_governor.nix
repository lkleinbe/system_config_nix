{ config, pkgs, lib, ... }: {
  boot.kernelParams = [
    "intel_pstate=enable" # intel pstate driver to change gpu frequency
    "intel_idle_max_cstate=1" # intel
    "energy_perf_bias=performance"
    "processor.max_cstate=1" # amd
  ];
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = { CPU_ENERGY_PERF_POLICY_ON_AC = "performance"; };
  };

  services.udev.extraRules = ''
    # Disable USB power management for all devices
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
  '';

}
