cask "labroute" do
  version "1.0.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://github.com/mariusrueve/labroute/releases/download/v#{version}/LabRoute-#{version}.zip"
  name "LabRoute"
  desc "Route journal and lab websites through an SSH tunnel to your lab server"
  homepage "https://github.com/mariusrueve/labroute"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia

  app "LabRoute.app"
  binary "#{appdir}/LabRoute.app/Contents/MacOS/labroute"

  # Disconnect first so LabRoute restores the previous proxy settings.
  uninstall script: {
    executable:   "#{appdir}/LabRoute.app/Contents/MacOS/labroute",
    args:         ["quit", "--wait"],
    must_succeed: false,
  }

  zap trash: "~/Library/Application Support/LabRoute"

  caveats <<~EOS
    LabRoute is not notarized. On first launch, allow it once in
      System Settings → Privacy & Security → Open Anyway
  EOS
end
