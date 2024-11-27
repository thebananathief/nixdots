{pkgs, homeDir ? pkgs.lib.getHome} :
pkgs.writeShellScriptBin "cursor" ''
    # Find the latest cursor AppImage in ~/Applications
    echo "Home Directory: ${homeDir}"
    cursor_app="$(find ${homeDir}/Applications -maxdepth 1 -name 'cursor*.AppImage' | sort | tail -n 1)"
    if [[ -f "$cursor_app" ]]; then
        # Execute the AppImage if found
        appimage-run "$cursor_app" "$@"
    else
        echo "Cursor AppImage not found or not executable in ~/Applications."
        exit 1
    fi
''
