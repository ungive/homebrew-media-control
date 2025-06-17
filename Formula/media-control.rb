class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/mediaremote-adapter"
  url "https://github.com/ungive/mediaremote-adapter/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "75183b5d6a541d20c2d21d8a6585e852baba4b40de3b08b448ba25e9d9d54537"
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
