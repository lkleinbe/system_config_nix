{ pkgs, inputs, lib, ... }: {

  # This allows SUID for mount-cifs. This is required, so that nautilus can mount the shares, when requested
  security.wrappers.mount-cifs = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };
  # The Credentions are stored in secrets/smb. You need to create that file to store the credentials
  fileSystems."/mnt/backup_share" = {
    device = "//192.168.2.254/backup_share";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.mount-timeout=120"
      "soft"
      "_netdev"
      "x-systemd.after=network-online.target"
      "x-gvfs-show"
      "x-gvfs-name=Backup Share"
      "credentials=/etc/nixos/secrets/smb"
      "vers=3.0"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "nofail"
    ];
  };
  fileSystems."/mnt/jonas_share" = {
    device = "//192.168.2.254/jonas_share";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.mount-timeout=120"
      "soft"
      "_netdev"
      "x-systemd.after=network-online.target"
      "x-gvfs-show"
      "x-gvfs-name=Jonas Share"
      "credentials=/etc/nixos/secrets/smb"
      "vers=3.0"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "nofail"
    ];
  };
  fileSystems."/mnt/kleinberger_share" = {
    device = "//192.168.2.254/kleinberger_share";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.mount-timeout=120"
      "soft"
      "_netdev"
      "x-systemd.after=network-online.target"
      "x-gvfs-show"
      "x-gvfs-name=Kleinberger Share"
      "credentials=/etc/nixos/secrets/smb"
      "vers=3.0"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "nofail"
    ];
  };
  fileSystems."/mnt/leonard_share" = {
    device = "//192.168.2.254/leonard_share";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.mount-timeout=120"
      "soft"
      "_netdev"
      "x-systemd.after=network-online.target"
      "x-gvfs-show"
      "x-gvfs-name=Leonard Share"
      "credentials=/etc/nixos/secrets/smb"
      "vers=3.0"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "nofail"
    ];
  };
  fileSystems."/mnt/public_share" = {
    device = "//192.168.2.254/public_share";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.mount-timeout=120"
      "soft"
      "_netdev"
      "x-systemd.after=network-online.target"
      "x-gvfs-show"
      "x-gvfs-name=Public Share"
      "credentials=/etc/nixos/secrets/smb"
      "vers=3.0"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "nofail"
    ];
  };

  # Ensure network-online.target is properly reached
  systemd.network.wait-online.enable = true;

  services.gvfs.enable = true;
}
