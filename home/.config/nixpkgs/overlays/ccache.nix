self: super: {
  ccacheWrapper = super.ccacheWrapper.override {
    extraConfig = ''
      export CCACHE_COMPRESS=1
      export CCACHE_COMPILERCHECK=content
      export CCACHE_SLOPPINESS=include_file_ctime,include_file_mtime,random_seed
      export CCACHE_BASEDIR="$(pwd)"
      export CCACHE_NOHASHDIR=1
      export CCACHE_DIR="/nix/var/cache/ccache"
      export CCACHE_UMASK=007
      if [ ! -d "$CCACHE_DIR" ]; then
        echo "====="
        echo "Directory '$CCACHE_DIR' does not exist"
        echo "====="
        exit 1
      fi
      if [ ! -w "$CCACHE_DIR" ]; then
        echo "====="
        echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
        echo "Please verify its access permissions"
        echo "====="
        exit 1
      fi
    '';
  };
}
