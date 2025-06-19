class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a9782069463b709c4afd7441416b09bd40ef6d7ae4bb54e350063daea0b38d99"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/media-control get").strip
    parsed = JSON.parse(output)
    # The output is either null or a dictionary with at least the given keys.
    if parsed.nil?
    else
      # Application bundle identifier
      assert parsed.is_a?(Hash)
      assert parsed.key?("bundleIdentifier")
      assert parsed["bundleIdentifier"].is_a?(String)
      assert !parsed["bundleIdentifier"].empty?
      # Media playback state
      assert parsed.key?("playing")
      assert parsed["playing"].is_a?(TrueClass) || parsed["playing"].is_a?(FalseClass)
      # Media title
      assert parsed.key?("title")
      assert parsed["title"].is_a?(String)
      assert !parsed["title"].empty?
    end
  end
end
