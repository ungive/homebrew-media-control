class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/mediaremote-adapter"
  url "https://github.com/ungive/mediaremote-adapter/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "5f660515f59af355a539f5effd4b7fd0b9297b7197f523ad7da9f8c44d1fb419"
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
    assert_equal "null", shell_output("#{bin}/media-control get").strip
  end
end
