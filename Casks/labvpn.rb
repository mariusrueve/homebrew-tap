cask "labvpn" do
  version "0.3.1"
  sha256 "6be591b83051f00f5164cf36d5d3ed4441cc9d187f07451f673877f67fba678b"

  url "https://github.com/mariusrueve/labvpn/releases/download/v#{version}/labvpn-#{version}.zip"
  name "labvpn"
  desc "Menu-bar client for Cisco AnyConnect VPNs, built on OpenConnect"
  homepage "https://github.com/mariusrueve/labvpn"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "labvpn.app"
  binary "#{appdir}/labvpn.app/Contents/MacOS/labvpn"

  # Quitting logs the tunnel off. The helper stays, so upgrades don't remove it.
  uninstall quit: "de.mariusrueve.labvpn"

  zap launchctl: "de.mariusrueve.labvpn.helper",
      delete:    [
        "/Library/LaunchDaemons/de.mariusrueve.labvpn.helper.plist",
        "/Library/PrivilegedHelperTools/labvpn",
      ],
      trash:     [
        "~/Library/Application Support/labvpn",
        "~/Library/LaunchAgents/de.mariusrueve.labvpn.plist",
        "~/Library/Logs/labvpn",
      ]

  caveats <<~EOS
    labvpn installs a root helper on first use. To remove it, use
    Settings → Helper → Uninstall before uninstalling, or run:
      brew uninstall --zap --cask labvpn
  EOS
end
