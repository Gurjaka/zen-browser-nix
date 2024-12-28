{
  lib,
  libGL,
  libGLU,
  libevent,
  libffi,
  libjpeg,
  libpng,
  libstartup_notification,
  libvpx,
  libwebp,
  stdenv,
  fontconfig,
  libxkbcommon,
  zlib,
  freetype,
  gtk3,
  libxml2,
  dbus,
  xcb-util-cursor,
  alsa-lib,
  libpulseaudio,
  pango,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  udev,
  libva,
  mesa,
  libnotify,
  cups,
  pciutils,
  ffmpeg,
  libglvnd,
  pipewire,
  speechd,
  libxcb,
  libX11,
  libXcursor,
  libXrandr,
  libXi,
  libXext,
  libXcomposite,
  libXdamage,
  libXfixes,
  libXScrnSaver,
  makeWrapper,
  copyDesktopItems,
  wrapGAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zen-browser";
  version = "1.0.2-b.5";

  src = builtins.fetchTarball {
    url = "https://github.com/zen-browser/desktop/releases/download/${finalAttrs.version}/zen.linux-x86_64.tar.bz2";
    sha256 = "sha256:1xp0z86l7z661cwckgr623gwwjsy3h66900xqjq6dvgx5a3njbxi";
  };

  runtimeLibs = [
    libGL
    libGLU
    libevent
    libffi
    libjpeg
    libpng
    libstartup_notification
    libvpx
    libwebp
    stdenv.cc.cc
    fontconfig
    libxkbcommon
    zlib
    freetype
    gtk3
    libxml2
    dbus
    xcb-util-cursor
    alsa-lib
    libpulseaudio
    pango
    atk
    cairo
    gdk-pixbuf
    glib
    udev
    libva
    mesa
    libnotify
    cups
    pciutils
    ffmpeg
    libglvnd
    pipewire
    speechd
    libxcb
    libX11
    libXcursor
    libXrandr
    libXi
    libXext
    libXcomposite
    libXdamage
    libXfixes
    libXScrnSaver
  ];

  desktopSrc = ./.;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    wrapGAppsHook
  ];

  installPhase = ''
    mkdir -p $out/{bin,opt/zen} && cp -r $src/* $out/opt/zen
    ln -s $out/opt/zen/zen $out/bin/zen

    install -D $desktopSrc/zen.desktop $out/share/applications/zen.desktop

    for i in 16 32 48 64 128; do
        install -Dm 644 $src/browser/chrome/icons/default/default$i.png \
          $out/share/icons/hicolor/$ix$i/apps/zen.png
    done
  '';

  fixupPhase =
    let
      ld-lib-path = lib.makeLibraryPath finalAttrs.runtimeLibs;
    in
    ''
      chmod 755 $out/bin/zen $out/opt/zen/*
      interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)

      for bin in zen zen-bin; do
         patchelf --set-interpreter "$interpreter" $out/opt/zen/$bin
         wrapProgram $out/opt/zen/$bin \
             --set LD_LIBRARY_PATH "${ld-lib-path}" \
             --set MOZ_LEGACY_PROFILES 1 \
             --set MOZ_ALLOW_DOWNGRADE 1 \
             --set MOZ_APP_LAUNCHER zen \
             --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
      done;

      for bin in glxtest updater vaapitest; do
          patchelf --set-interpreter "$interpreter" $out/opt/zen/$bin
          wrapProgram $out/opt/zen/$bin \
              --set LD_LIBRARY_PATH "${ld-lib-path}"
      done;
    '';

  meta = {
    changelog = "https://zen-browser.app/release-notes/#${finalAttrs.version}";
    homepage = "https://zen-browser.app/";
    description = "Experience tranquillity while browsing the web without people tracking you";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gurjaka
      sigmanificient
    ];
    mainProgram = "zen";
  };
})
