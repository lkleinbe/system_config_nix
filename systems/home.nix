{ config, pkgs, lib, ... }: {
  imports = [ ../modules/base.nix ../modules/dconf/dconf_desktop1.nix ];
  networking.hostName = "dumba-home";
  system.stateVersion = "25.05";

  # NOTE: Uncomment this if you want to use secure boot
  # To use secure boot there is a 5 step process:
  # 1. run sudo sbctl create-keys
  # 2. uncomment the code block below and rebuild-switch
  # 3. reboot and with secure boot enabled in setup mode
  # 4. run sudo sbctl enroll-keys --microsoft
  # 5. reboot again
  # 6. (you can use bootctl and sbctl status to check the secure boot status)

  boot.loader.systemd-boot.enable = false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  #User Configuration
  users.users.dumba = {
    isNormalUser = true;
    description = "dumba";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" ];
    # user packages
    packages = with pkgs;
      [
        #  thunderbird
      ];
    openssh.authorizedKeys.keyFiles =
      [ ../public_ssh_keys/work_laptop_ssh.pub ];
  };

  # services.openssh.settings.PasswordAuthentication =
  #   true; # NOTE uncomment this to allow SSH Password authentication

  # Use the local private key of user for authentication in the gitlab for this system flake
  programs.ssh.extraConfig = ''
    Host gitlab.com
    User git
    IdentityFile /home/dumba/.ssh/id_ed25519
  '';

  #printing setup
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  #scanning setup
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];

  # system packages
  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      typst
      godot_4_4
      discord
      # htop
    ])
  ];

  # This fixes the wavexlr microphone bug on nixos.
  # See https://jmansar.github.io/wavexlr-on-linux-cfg/ for explanation
  # TODO: Move this to own module
  services.pipewire.wireplumber.extraConfig."51-wavexlr" = {
    "wireplumber.components" = [{
      name = "wavexlrfix.lua";
      type = "script/lua";
      provides = "custom.wavexlrfix";
    }];

    "wireplumber.profiles" = { main = { "custom.wavexlrfix" = "required"; }; };

    "monitor.alsa.rules" = [
      {
        "matches" = [{
          "node.name" = "~alsa_output.usb-Elgato_Systems_Elgato_Wave_XLR_*";
        }];
        "actions" = { "update-props" = { "node.disabled" = true; }; };
      }
      {
        "matches" = [{
          "node.name" = "~alsa_input.usb-Elgato_Systems_Elgato_Wave_XLR_*";
        }];
        "actions" = { "update-props" = { "node.name" = "wavexlr-source"; }; };
      }
    ];
  };
  services.pipewire.wireplumber.extraScripts."wavexlrfix.lua" = ''

    -- This script creates a virtual sink to link Wave XLR source (mirophone input) to.
    -- After the link is estabilished it creates Wave XLR sink (playback output).
    log = Log.open_topic('s-wavexlrfix')

    waveXlrSourceOm = ObjectManager {
        Interest {
            type = 'node',
            Constraint { 'node.name', 'matches', 'wavexlr-source' },
        }
    }

    linkOm = ObjectManager {
        Interest {
            type = 'link',
        }
    }

    devicesOm = ObjectManager {
        Interest {
            type = 'device',
        }
    }

    waveXlrSinkNode = nil
    nullSinkForWaveXlrSource = nil
    nullSinkLink = nil

    function createLinkForWaveXlrSource(waveXlrSourceNode)
        local outPort = nil
        local inPort = nil

        local outInterest = Interest {
            type = 'port',
            Constraint { 'node.id', 'equals', waveXlrSourceNode.properties['object.id'] },
            Constraint { 'port.direction', 'equals', 'out' }
        }

        local inInterest = Interest {
            type = 'port',
            Constraint { 'node.id', 'equals', nullSinkForWaveXlrSource.properties['object.id'] },
            Constraint { 'port.direction', 'equals', 'in' }
        }

        local portOm = ObjectManager {
            Interest {
                type = 'port',
            }
        }

        function onPortAdded()
            if not nullSinkLink then
                for port in portOm:iterate(outInterest) do
                    outPort = port
                end

                for port in portOm:iterate(inInterest) do
                    inPort = port
                end

                if inPort and outPort and inPort.properties['object.id'] and outPort.properties['object.id'] then
                    local args = {
                        ['link.input.node'] = nullSinkForWaveXlrSource.properties['object.id'],
                        ['link.input.port'] = inPort.properties['object.id'],

                        ['link.output.node'] = waveXlrSourceNode.properties['object.id'],
                        ['link.output.port'] = outPort.properties['object.id'],
                    }

                    log:notice('Creating link between null sink and WaveXLR source. Ports: ' ..
                        args['link.input.node'] ..
                        '-' ..
                        args['link.input.port'] .. ' -> ' .. args['link.output.node'] .. '-' .. args['link.output.port'])

                    nullSinkLink = Link('link-factory', args)

                    nullSinkLink:activate(Feature.Proxy.BOUND, function(n, err)
                        if err then
                            log:warning('Failed to create link between null sink and WaveXLR source'
                                .. ': ' .. tostring(err))
                            node = nil
                        else
                            log:notice('Created link between null sink and WaveXLR source')
                        end
                    end)
                end
            end
        end

        portOm:connect('object-added', onPortAdded)
        portOm:activate()
    end

    function onLinkCreated(_, link)
        if nullSinkLink and link.properties['object.id'] == nullSinkLink.properties['object.id'] then
            for node in waveXlrSourceOm:iterate() do
                createWaveXlrSink(node)
            end
        end
    end

    function createWaveXlrSink(sourceNode)
        local deviceInterest = Interest {
            type = 'device',
            Constraint { 'object.id', 'equals', sourceNode.properties['device.id'] }
        }

        for device in devicesOm:iterate(deviceInterest) do
            local sinkNodeProperties = {
                ['device.id'] = sourceNode.properties['device.id'],
                ['factory.name'] = 'api.alsa.pcm.sink',
                ['node.name'] = 'wavexlr-sink',
                ['node.description'] = 'WaveXLR Sink',
                ['node.nick'] = 'WaveXLR Sink',
                ['media.class'] = 'Audio/Sink',
                ['api.alsa.path'] = sourceNode.properties['api.alsa.path'],
                ['api.alsa.pcm.card'] = sourceNode.properties['api.alsa.pcm.card'],
                ['api.alsa.pcm.stream'] = 'playback',
                ['alsa.resolution_bits'] = '24',
                ['audio.channels'] = '2',
                ['audio.position'] = 'FL,FR',
                ['priority.driver'] = '1000',
                ['priority.session'] = '1000',
                ['node.pause-on-idle'] = 'false',
            }

            for k, v in pairs(device.properties) do
                if k:find('^api%.alsa%.card%..*') then
                    sinkNodeProperties[k] = v
                end
            end

            log:notice('Creating custom WaveXLR sink. api.alsa.path: ' .. sourceNode.properties['api.alsa.path'])

            waveXlrSinkNode = Node('adapter', sinkNodeProperties)
            waveXlrSinkNode:activate(Feature.Proxy.BOUND, function(n, err)
                if err then
                    log:warning('Failed to create ' .. sinkNodeProperties['node.name']
                        .. ': ' .. tostring(err))
                    waveXlrSinkNode = nil
                else
                    log:notice('Created custom WaveXLR sink. object.id: ' .. n.properties['object.id'])
                end
            end)
        end
    end

    function onWaveXlrSourceAdded(_, node)
        createLinkForWaveXlrSource(node)
    end

    function createNullSink()
        local properties = {
            ['factory.name'] = 'support.null-audio-sink',
            ['node.name'] = 'null-sink-for-wavexlr-source',
            ['node.description'] = 'Null Sink For WaveXLR Source - do not use',
            ['node.nick'] = 'Null Sink For WaveXLR Source - do not use',
            ['media.class'] = 'Audio/Sink',
            ['monitor.channel-volumes'] = 'true',
            ['monitor.passthrough'] = 'true',
            ['audio.channels'] = '1',
            ['audio.position'] = 'MONO',
            ['node.passive'] = 'false'
        }

        log:notice('Creating custom null sink for WaveXLR Source')

        local node = Node('adapter', properties)

        node:activate(Feature.Proxy.BOUND, function(n, err)
            if err then
                log:warning('Failed to create ' .. properties['node.name']
                    .. ': ' .. tostring(err))
                node = nil
            else
                log:notice('Created null sink for WaveXLR source. object.id: ' ..
                    n.properties['object.id'])
            end
        end)

        return node
    end

    function onWaveXlrSourceRemoved()
        if waveXlrSinkNode then
            log:notice('Removing custom WaveXLR sink');
            waveXlrSinkNode:request_destroy()
            waveXlrSinkNode = nil
        end

        if nullSinkLink then
            log:notice('Removing null sink link');
            nullSinkLink:request_destroy()
            nullSinkLink = nil
        end
    end

    nullSinkForWaveXlrSource = createNullSink();

    devicesOm:activate()
    linkOm:activate()
    linkOm:connect('object-added', onLinkCreated)
    waveXlrSourceOm:connect('object-added', onWaveXlrSourceAdded)
    waveXlrSourceOm:connect('object-removed', onWaveXlrSourceRemoved)
    waveXlrSourceOm:activate()

    log:notice('script initialized')
  '';
}
