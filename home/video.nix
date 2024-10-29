{ pkgs, ... }: {
  home.packages = with pkgs; [
    davinci-resolve
    nvtopPackages.intel
    ffmpeg
  ];
}
