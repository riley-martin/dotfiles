{ inputs, lib, pkgs, ... }: let 
  mod = "SUPER";
  exec = {
    brightnessctl = "${lib.getExe pkgs.brightnessctl}";
    wpctl = "${pkgs.wireplumber}/bin/wpctl";
  };
in {
  imports = [ inputs.hyprland-nix.homeManagerModules.default ];
  wayland.windowManager.hyprland = {
    enable = true;
    reloadConfig = true;
    systemdIntegration = true;
    config = {
      monitor = [
        ", preferred, auto, 1"
      ];
      general = {
        layout = "dwindle";
        border_size = 2;
        gaps_inside = 2;
        gaps_outside = 4;
        active_border_color = "rgb(444aaa)";
        inactive_border_color = "rgb(222777)";
        cursor_inactive_timeout = 4;
        resize_on_border = true;
        extend_border_grab_area = 4;
      };
      decoration = {
        rounding = 8;
        shadow_range = 8;
        shadow_render_power = 2;
        active_shadow_color = "rgb(111111)";
        inactive_shadow_color = "rgb(222222)";
        blur = {
          size = 4;
          passes = 1;
          ignore_opacity = false;
          xray = true;
          noise = 6.3e-2;
          contrast = 0.75;
          brightness = 0.8;
        };
      };
      input = {
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };
      blurls = [ "waybar" "gtk-layer-shell" ];
      gestures =  {
        workspace_swipe = {
          enable = true;
          invert = true;
          min_speed_to_force = 16;
          cancel_ratio = 0.65;
          create_new = true;
          forever = false;
        };
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
      };
      exec_once = [
        # exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 
        # # exec-once = udiskie &
        "${lib.getExe pkgs.wpaperd}"
        # exec-once = wluma
        # exec-once = dunst
        "${lib.getExe pkgs.dunst}"
        # exec-once = gestures
        # exec-once = /usr/bin/pipewire & /usr/bin/pipewire-pulse & /usr/bin/wireplumber
        "${lib.getExe pkgs.eww} open bar"
        # exec-once = swayidle -w timeout 120 'hyprctl dispatch dpms off' timeout 125 '${swaylock}' resume 'hyprctl dispatch dpms on'
      ];
    };
    keyBinds = {
      bind = {
        "${mod}_SHIFT, M" = "exit,";
        "${mod}, R" = "exec, rofi -show run";
        "${mod}, Space" = "exec, rofi -show drun -show-icons";
        "${mod}, Return" = "exec, alacritty";
        "${mod}, Backspace" = "killactive,";


        "${mod}, h" = "movefocus, l";
        "${mod}_Shift, h" = "resizeactive, -40 0";
        "${mod}_Ctrl, h" = "movewindow, l";

        "${mod}, l" = "movefocus, r";
        "${mod}_Shift, l" = "resizeactive, 40 0";
        "${mod}_Ctrl, l" = "movewindow, r";

        "${mod}, k" = "movefocus, u";
        "${mod}_Shift, k" = "resizeactive, 0 -40";
        "${mod}_Ctrl, k" = "movewindow, u";

        "${mod}, j" = "movefocus, d";
        "${mod}_Shift, j" = "resizeactive, 0 40";
        "${mod}_Ctrl, j" = "movewindow, d";


        "${mod}, F" = "fullscreen, 1";
        "${mod}_Shift, F" = "fullscreen, 0";
        "${mod}, S" = "togglespecialworkspace";
        "${mod}_Shift, S" = "movetoworkspace, special";


        "${mod}, T" = "togglegroup";        
        "${mod}, Tab" = "changegroupactive, f";
        "${mod}_Shift, Tab" = "changegroupactive, b";

        "${mod}, &" = "workspace, 1";        
        "${mod}, [" = "workspace, 2";
        "${mod}, {" = "workspace, 3";
        "${mod}, }" = "workspace, 4";
        "${mod}, (" = "workspace, 5";
        "${mod}, =" = "workspace, 6";
        "${mod}, *" = "workspace, 7";
        "${mod}, )" = "workspace, 8";
        "${mod}, +" = "workspace, 9";
        "${mod}, ]" = "workspace, 10";

        "${mod}_Shift, &" = "movetoworkspace, 1";
        "${mod}_Shift, [" = "movetoworkspace, 2";
        "${mod}_Shift, {" = "movetoworkspace, 3";
        "${mod}_Shift, }" = "movetoworkspace, 4";
        "${mod}_Shift, (" = "movetoworkspace, 5";
        "${mod}_Shift, =" = "movetoworkspace, 6";
        "${mod}_Shift, *" = "movetoworkspace, 7";
        "${mod}_Shift, )" = "movetoworkspace, 8";
        "${mod}_Shift, +" = "movetoworkspace, 9";
        "${mod}_Shift, ]" = "movetoworkspace, 10";
      };
      bindel = {
        ", XF86AudioRaiseVolume" = "exec, ${exec.wpctl} set-volume '@DEFAULT_SINK@' 2%+";
        ", XF86AudioLowerVolume" = "exec, ${exec.wpctl} set-volume '@DEFAULT_SINK@' 2%-";
        ", XF86MonBrightnessUp" = "exec, ${exec.brightnessctl} set 4%+";
        ", XF86MonBrightnessDown" = "exec, ${exec.brightnessctl} set 4%-";
      };
      bindl = {
        ", XF86AudioMute" = "exec, ${exec.wpctl} set-mute '@DEFAULT_SINK@' toggle";
      };
      bindm = {
        "${mod}, mouse:272" = "movewindow";
        "${mod}, mouse:273" = "resizewindow";
      };
    };
  };
}

# env,GDK_BACKEND,"wayland";
# env,XCURSOR_SIZE,24;
# env,QT_QPA_PLATFORM,"wayland;xcb";
# env,QT_QPA_PLATFORMTHEME,"qt5ct";
# env,WLR_DRM_NO_MODIFIERS,1;

# windowrule = size 440 480, class:^(gimp.*)$, title:^(Search Actions)$
# windowrulev2 = rounding 2, xwayland:1
# windowrulev2 = opaque, class:^(org.freecadweb.FreeCAD)$

# bind = $mod, M, exec, ${swaylock} -f -c 000000
# bind = $mod, V, togglefloating,
# bind = , Print, exec, grim
# bind = SHIFT, Print, exec, slurp | grim

# bind = , F1, workspace, 1
# bind = , F2, workspace, 2
# bind = , F3, workspace, 3
# bind = , F4, workspace, 4
# bind = , F5, workspace, 5
# bind = , F6, workspace, 6
# bind = , F7, workspace, 7
# bind = , F8, workspace, 8
# bind = , F9, workspace, 9
# bind = , F10, workspace, 10

# bind = SHIFT, F1, movetoworkspace, 1
# bind = SHIFT, F2, movetoworkspace, 2
# bind = SHIFT, F3, movetoworkspace, 3
# bind = SHIFT, F4, movetoworkspace, 4
# bind = SHIFT, F5, movetoworkspace, 5
# bind = SHIFT, F6, movetoworkspace, 6
# bind = SHIFT, F7, movetoworkspace, 7
# bind = SHIFT, F8, movetoworkspace, 8
# bind = SHIFT, F9, movetoworkspace, 9
# bind = SHIFT, F10, movetoworkspace, 10
