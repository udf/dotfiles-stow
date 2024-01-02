
self: super:
let
  nixgl = import <nixgl> {};
  nixgl-wrapper = self.writeShellScriptBin "nixgl-wrapper" ''
    ${nixgl.auto.nixGLDefault}/bin/nixGL @PATH@
  '';
in
{
  # tdesktop-custom = {...}; ????????
  tdesktop = super.tdesktop.overrideAttrs (oldAttrs: rec {
    patches = (oldAttrs.patches or []) ++ [
      ./tdesktop-udf-patches/always_clear_history_for_everyone.patch
      ./tdesktop-udf-patches/always_pin_without_notify.patch
      ./tdesktop-udf-patches/always_send_sticker_as_file.patch
      ./tdesktop-udf-patches/use_tagbot_for_gifs_search.patch
    ];

    # TODO: move this into separate derivation
    postFixup = ''
      wrapProgram $out/bin/telegram-desktop \
        --argv0 'telegram-desktop' \
        "''${gappsWrapperArgs[@]}" \
        "''${qtWrapperArgs[@]}" \
        --set XDG_CURRENT_DESKTOP Unity \
        --prefix XDG_DATA_DIRS : /usr/share \
        --prefix XCURSOR_PATH : /usr/share/icons \
        --prefix LD_LIBRARY_PATH : ${self.xorg.libXcursor}/lib

      mv $out/bin/telegram-desktop $out/bin/.telegram-desktop
      cp ${nixgl-wrapper}/bin/nixgl-wrapper $out/bin/telegram-desktop
      substituteInPlace $out/bin/telegram-desktop \
        --replace '@PATH@' "$out/bin/.telegram-desktop"
    '';
  });
}