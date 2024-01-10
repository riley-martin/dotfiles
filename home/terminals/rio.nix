{ ... }: {
  programs.rio = {
    enable = true;
    settings = {
      cursor = "|";
      editor = "hx";
      hide-cursor-when-typing = false;
      padding-x = 8;
      background-opacity = 0.7;
      decorations = "Disabled";
    };
  };
}
