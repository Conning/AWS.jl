module AWS
using HTTPClient.HTTPC
using JSON
using LibExpat


const EP_US_EAST_NORTHERN_VIRGINIA     = "ec2.us-east-1.amazonaws.com"
const EP_US_WEST_OREGON                = "ec2.us-west-2.amazonaws.com"
const EP_US_WEST_NORTHERN_CALIFORNIA   = "ec2.us-west-1.amazonaws.com"
const EP_EU_IRELAND                    = "ec2.eu-west-1.amazonaws.com"
const EP_AP_SINGAPORE                  = "ec2.ap-southeast-1.amazonaws.com"
const EP_AP_SYDNEY                     = "ec2.ap-southeast-2.amazonaws.com"
const EP_AP_TOKYO                      = "ec2.ap-northeast-1.amazonaws.com"
const EP_SA_SAO_PAULO                  = "ec2.sa-east-1.amazonaws.com"

export EP_US_EAST_NORTHERN_VIRGINIA, EP_US_WEST_OREGON, EP_US_WEST_NORTHERN_CALIFORNIA
export EP_EU_IRELAND, EP_AP_SINGAPORE, EP_AP_SYDNEY, EP_AP_TOKYO, EP_SA_SAO_PAULO


const AP_NORTHEAST_1 = "ap-northeast-1" # Asia Pacific (Tokyo) Region
const AP_SOUTHEAST_1 = "ap-southeast-1" # Asia Pacific (Singapore) Region
const AP_SOUTHEAST_2 = "ap-southeast-2" # Asia Pacific (Sydney) Region
const EU_WEST_1 = "eu-west-1" # EU (Ireland) Region
const SA_EAST_1 = "sa-east-1" # South America (Sao Paulo) Region
const US_EAST_1 = "us-east-1" # US East (Northern Virginia) Region
const US_WEST_1 = "us-west-1" # US West (Northern California) Region
const US_WEST_2 = "us-west-2" # US West (Oregon) Region

# Search for default AWS_ID and AWS_SECKEY
AWS_ID = ""
AWS_SECKEY = ""
AWS_TOKEN = ""
if haskey(ENV, "AWS_ID") && haskey(ENV, "AWS_SECKEY")
    AWS_ID = ENV["AWS_ID"]
    AWS_SECKEY = ENV["AWS_SECKEY"]
else
    secret_path = "$(homedir())/.awssecret"
    @windows_only begin
        secret_path = "$(ENV["APPDATA"])/.awssecret"
    end

    if isfile(secret_path)
        AWS_ID, AWS_SECKEY = split(readchomp(open(secret_path)))
    end
end

type AWSEnv
    aws_id::ASCIIString         # AWS Access Key id
    aws_seckey::ASCIIString     # AWS Secret key for signing requests
    aws_token::ASCIIString      # AWS Security Token for temporary credentials
    region::AbstractString      # region name
    ep_scheme::ASCIIString      # URL scheme: http or https
    ep_host::AbstractString     # region endpoint (host)
    ep_path::AbstractString     # region endpoint (path)
    sig_ver::Int                # AWS signature version (2 or 4)
    timeout::Float64            # request timeout in seconds, default is no timeout.
    dry_run::Bool               # If true, no actual request will be made - implies dbg flag below
    dbg::Bool                   # print request to screen


    function AWSEnv(; id=AWS_ID, key=AWS_SECKEY, token=AWS_TOKEN, ec2_creds=false, scheme="https", region=US_EAST_1, ep="", sig_ver=4, timeout=0.0, dr=false, dbg=false)
        if ec2_creds
            creds = get_instance_credentials()
            if creds != nothing
                id = creds["AccessKeyId"]
                key = creds["SecretAccessKey"]
                token = creds["Token"]
            end
        end

        if (id == "") || (key == "")
            error("Invalid AWS security credentials provided")
        end

        ep_scheme, ep_host, ep_path = parse_endpoint(ep, scheme)

        # host portion of ep overrides region
        if length(ep_host) > 19 && ep_host[1:4] == "ec2." && ep_host[(end-13):end] == ".amazonaws.com"
            println("WARNING: AWSEnv: ep keyword argument has been deprecated for AWS native services.")
            println("Use region keyword argument instead.")
            region = ep_host[5:end-14]
            ep_host = ""
        end
        if ep_host != ""
            region = ""
        end
        if (region == "" && ep == "")
            error("No region or endpoint provided")
        end

        if sig_ver != 2 && sig_ver != 4
          error("Invalid signature version number")
        end

        if dr
            new(id, key, token, region, ep_scheme, ep_host, ep_path, sig_ver, timeout, dr, true)
        else
            new(id, key, token, region, ep_scheme, ep_host, ep_path, sig_ver, timeout, false, dbg)
        end
    end

    function AWSEnv(env::AWSEnv; ep="")
        ep_scheme, ep_host, ep_path = parse_endpoint(ep, env.ep_scheme)

        new(env.aws_id, env.aws_seckey, env.aws_token, env.region, ep_scheme,
            ep_host, ep_path, env.sig_ver, env.timeout, env.dry_run, env.dbg)
    end

end
export AWSEnv

function parse_endpoint(ep, default_scheme)
    s = search(ep,"://")
    if length(s) == 0
        ep_scheme = default_scheme
        ephp = ep
    else
        ep_scheme = ep[1:(first(s)-1)]
        ephp = ep[first(s)+3:end]
    end
    s = search(ephp,"/")
    if length(s) == 0
        ep_host = ephp
        ep_path = "/"
    else
        ep_host = ephp[1:(first(s)-1)]
        ep_path = ephp[first(s):end]
    end
    return (ep_scheme, ep_host, ep_path)
end

ep_host(env::AWSEnv, service) = lowercase(env.ep_host=="" ? "$service.$(env.region).amazonaws.com" : env.ep_host)
export ep_host

function get_instance_credentials()
    try
        if getaddrinfo("instance-data.ec2.internal.") != ip"169.254.169.254"
            return nothing
        end

        url = "http://169.254.169.254/2014-11-05/meta-data/iam/security-credentials/"
        resp = HTTPC.get(url, HTTPC.RequestOptions())
        if resp.http_code != 200
            return nothing
        end

        iam = split(bytestring(resp.body.data))
        if length(iam) == 0
            return nothing
        end

        url *= iam[1]
        resp = HTTPC.get(url, HTTPC.RequestOptions())
        if resp.http_code != 200
            return nothing
        end

        return JSON.Parser.parse(bytestring(resp.body.data))
    catch
        return nothing
    end
end


include("aws_utils.jl")
include("crypto.jl")
include("sign.jl")
include("EC2.jl")
include("S3.jl")
include("SQS.jl")

include("show.jl")


end
