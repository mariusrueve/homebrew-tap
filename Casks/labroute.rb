cask "labroute" do
  version "1.2.1"
  sha256 "fbc2a918156729bc557aa120934a47363fa860f4d6b177ea265b6233d0660590"

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
