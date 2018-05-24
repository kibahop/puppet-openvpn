# Construct a base URL for files. If none is given, use a backwards-compatible 
# default.
#
function openvpn::baseurl(Optional[String] $baseurl) >> String
{
    if $baseurl {
        $baseurl
    } else {
        $proto = 'puppet'
        $share = 'files'
        "${proto}:///${share}"
    }
}
