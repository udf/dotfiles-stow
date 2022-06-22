
self: super:
{
  tdesktop = super.tdesktop.overrideAttrs (oldAttrs: rec {
    patches = (oldAttrs.patches or []) ++ [
      ./tdesktop-udf-patches/always_delete_for_everyone.patch
      ./tdesktop-udf-patches/always_clear_history_for_everyone.patch
      ./tdesktop-udf-patches/always_pin_without_notify.patch
      ./tdesktop-udf-patches/always_send_as_photo_or_album.patch
      ./tdesktop-udf-patches/use_tagbot_for_gifs_search.patch
    ];

    postFixup = ''
      wrapProgram $out/bin/telegram-desktop \
        "''${gappsWrapperArgs[@]}" \
        "''${qtWrapperArgs[@]}" \
        --set XDG_CURRENT_DESKTOP Unity \
        --set QT_XCB_GL_INTEGRATION none \
        --prefix XDG_DATA_DIRS : /usr/share \
        --prefix XCURSOR_PATH : /usr/share/icons \
        --prefix LD_LIBRARY_PATH : ${self.xorg.libXcursor}/lib
    '';
  });
}