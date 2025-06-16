self: super:
let
  # nixgl = import <nixgl> { };
  # nixgl-wrapper = self.writeShellScriptBin "nixgl-wrapper" ''
  #   ${nixgl.auto.nixGLDefault}/bin/nixGL @PATH@
  # '';
  tdesktopPkg = super.tdesktop.override { stdenv = super.ccacheStdenv; };
in
{
  tdesktop = tdesktopPkg.overrideAttrs (oldAttrs: {
    unwrapped = oldAttrs.unwrapped.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        ./tdesktop-udf-patches/always_clear_history_for_everyone.patch
        ./tdesktop-udf-patches/always_pin_without_notify.patch
        ./tdesktop-udf-patches/always_send_sticker_as_file.patch
      ];
    });

    postFixup = ''
      ls $out/bin
      wrapProgram $out/bin/Telegram \
        --argv0 'Telegram' \
        "''${gappsWrapperArgs[@]}" \
        "''${qtWrapperArgs[@]}" \
        --set XDG_CURRENT_DESKTOP Unity \
        --prefix XDG_DATA_DIRS : /usr/share \
        --prefix XCURSOR_PATH : /usr/share/icons \
        --prefix LD_LIBRARY_PATH : ${self.xorg.libXcursor}/lib
      ln -s $out/bin/Telegram $out/bin/telegram-desktop
    '';
      # mv $out/bin/telegram-desktop $out/bin/.telegram-desktop
      # cp ${nixgl-wrapper}/bin/nixgl-wrapper $out/bin/telegram-desktop
      # substituteInPlace $out/bin/telegram-desktop \
      #   --replace-fail '@PATH@' "$out/bin/.telegram-desktop"
  });
}
