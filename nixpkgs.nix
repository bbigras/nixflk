let
  fetchNixOS = { repo, rev, sha256 }: builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/${repo}/tarball/${rev}";
  };

  nixpkgs = fetchNixOS {
    repo = "nixpkgs";
    rev = "251a5604492e364e90e606acba3bdf696ca5da0d";
    sha256 = "1r81wqqgxsmaz1jd42is9hls8siqrzp1333rqng8rn7j6fim4zmw";
  };
in
nixpkgs
