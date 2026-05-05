class NginxMarkdownModule < Formula
  desc "NGINX module for HTML-to-Markdown conversion"
  homepage "https://github.com/cnkang/nginx-markdown-for-agents"
  url "https://github.com/cnkang/nginx-markdown-for-agents/archive/refs/tags/v0.6.0.tar.gz"
  # SHA-256 from `git archive --format=tar.gz HEAD | shasum -a 256`.
  # PLACEHOLDER: This SHA matches the current HEAD commit only.
  # After pushing refs/tags/v0.6.0 to origin, regenerate from the GitHub archive:
  #   curl -sL https://github.com/cnkang/nginx-markdown-for-agents/archive/refs/tags/v0.6.0.tar.gz | sha256sum
  # GitHub archives include a commit-date prefix that differs from local
  # git-archive output, so the SHA WILL change after tagging.
  sha256 "eede79cbfe08b43491d622476d5583e6efdf596a238fcbddcd9af6266d68514a"
  license "BSD-2-Clause"

  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  def caveats
    <<~EOS
      This module requires NGINX to be built with the module loaded.
      Add to your nginx.conf:
        load_module #{opt_lib}/nginx/modules/ngx_http_markdown_filter_module.so;
    EOS
  end

  test do
    assert_path_exists lib/"nginx/modules/ngx_http_markdown_filter_module.so"
  end
end
