{ config, pkgs, ... }:

let
  # Указываем точный путь к вашей прошивке
  firmwarePath = "/home/zyzya/hp1020_firmware/sihp1020.dl";
  
  # Создаем скрипт, который udev будет безопасно вызывать при подключении
  # Имя принтера берем строго то, которое CUPS выдал ранее
  loadFirmwareScript = pkgs.writeShellScript "load-hp1020-firmware" ''
    if [ -f "${firmwarePath}" ]; then
      # Даем принтеру 2 секунды определиться в системе и шлем прошивку
      sleep 2
      ${pkgs.cups}/bin/lp -d Hewlett-Packard-HP-LaserJet-1020 -o raw "${firmwarePath}"
    fi
  '';
in
{
  nixpkgs.config.allowUnfree = true;

  # Настройка CUPS
  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      foo2zjs     
      gutenprint  
      cups-filters 
    ];
  };

  programs.system-config-printer.enable = true;

  environment.systemPackages = with pkgs; [
    foo2zjs
  ];

  # Добавляем udev-правило для автоматического триггера по USB ID устройства
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="03f0", ATTR{idProduct}=="2b17", RUN+="${loadFirmwareScript}"
  '';
}

