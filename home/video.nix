{ pkgs, ... }: {
  home.packages = with pkgs; [
    nvtopPackages.intel
    ffmpeg
  ];
}
