{ pkgs, ... }: {
  home.packages = with pkgs; [
    davinci-resolve
    nvtop-intel
    ffmpeg
  ];
}
