class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  # pull from git tag to get submodules
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.5.1",
      revision: "1a4c3f7f3a59c28a0e21c957bc0c9edf4dd00e2f"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

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
      # ok
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
