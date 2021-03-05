
self: super:
let
  defaultCursor = (self.callPackage ({ stdenv }: stdenv.mkDerivation {
    name = "global-cursor-theme";
    unpackPhase = "true";
    outputs = [ "out" ];
    installPhase = ''
      mkdir -p $out/share/icons/default
      cat << EOF > $out/share/icons/default/index.theme
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=Adwaita
      EOF
    '';
  }) {});
in
{
  tdesktop = super.tdesktop.overrideAttrs (oldAttrs: rec {
    patches = (oldAttrs.patches or []) ++ [
      ./tdesktop-udf-patches/always_delete_for_everyone.patch
      ./tdesktop-udf-patches/always_clear_history_for_everyone.patch
      ./tdesktop-udf-patches/always_pin_without_notify.patch
      ./tdesktop-udf-patches/always_send_as_photo_or_album.patch
    ];

    postFixup = ''
      # TODO: specify Arc-Dark GTK theme instead of assuming that it's set in system config
      wrapProgram $out/bin/telegram-desktop \
        "''${gappsWrapperArgs[@]}" \
        "''${qtWrapperArgs[@]}" \
        --set TDESKTOP_USE_GTK_FILE_DIALOG 1 \
        --set QT_XCB_GL_INTEGRATION none \
        --prefix XDG_DATA_DIRS : ${super.arc-theme}/share \
        --prefix XDG_DATA_DIRS : ${super.arc-icon-theme}/share \
        --prefix XCURSOR_PATH : ${super.gnome3.adwaita-icon-theme}/share/icons \
        --prefix XCURSOR_PATH : ${defaultCursor}/share/icons
    '';
  });
}