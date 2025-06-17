class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/mediaremote-adapter"
  url "https://github.com/ungive/mediaremote-adapter/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dc602973429940fe7b543641da861741a27dfda6bcd7c6b6e46245493f6c982d"
  license "BSD-3-Clause"
  head "https://github.com/ungive/mediaremote-adapter.git", branch: "master"

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
    # The output is either null or a dictionary with the given keys.
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
