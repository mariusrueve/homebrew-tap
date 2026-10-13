cask "labroute" do
  version "1.1.0"
  sha256 "c45e1e5198dfc59eda25938f78b674747b4a948fc9992f09a399e11b9729cd3c"

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
    executable:   "/bin/sh",
    args:         ["-c", '[ -x "$0" ] && "$0" quit --wait; exit 0',
                   "#{appdir}/LabRoute.app/Contents/MacOS/labroute"],
    must_succeed: false,
  }

  # The Include line in ~/.ssh/config and the ~/.zshrc line are harmless once
  # these are gone: ssh ignores a missing Include, the shell line checks for the app.
  zap trash: [
    "~/.ssh/labroute",
    "~/Library/Application Support/LabRoute",
  ]

  caveats <<~EOS
    LabRoute is not notarized. On first launch, allow it once in
      System Settings → Privacy & Security → Open Anyway
  EOS
end
