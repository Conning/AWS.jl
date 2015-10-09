module SQS

using LibExpat
using HTTPClient.HTTPC
using AWS.AWSEnv
using AWS


type SQSError
    typ::AbstractString
    code::AbstractString
    msg::AbstractString
    detail::AbstractString
    request_id::Union{AbstractString, Void}
end
export SQSError

sqs_error_str(o::SQSError) = "type: $(o.typ), code: $(o.code), msg : $(o.msg), $(o.request_id)"
export sqs_error_str


type SQSResponse
    http_code::Int
    headers
    body::Union{AbstractString, Void}
    pd::Union{ETree, Void}
    obj::Any

    SQSResponse() = new(0, Dict{Any, Any}(), "", nothing, nothing)
end
export SQSResponse


function sqs_execute(env_::AWSEnv, action::AbstractString, ep, params_in=Tuple[])
    # Adjust endpoint.
    env = env_
    if ep != nothing
        env = AWSEnv(env_; ep=ep)
    end

    # Prepare the standard params
    params = copy(params_in)

    push!(params, ("Action", action))
    push!(params, ("AWSAccessKeyId", env.aws_id))
    push!(params, ("Timestamp", get_utc_timestamp()))
    push!(params, ("Version", "2012-11-05"))
#    push!(params, ("Expires", get_utc_timestamp(300))) # Request expires after 300 seconds

    # Support GET for now; add POST later to support larger messages.
    amz_headers, signed_querystr = canonicalize_and_sign(env, "sqs", "GET", params)

    complete_url = "https://" * ep_host(env, "sqs") * env.ep_path * "?" * signed_querystr
    if (env.dbg) || (env.dry_run)
        println("URL:\n$complete_url\n")
    end

    #make the request
    sqsresp = SQSResponse()
    if !(env.dry_run)
        ro = HTTPC.RequestOptions(headers = amz_headers, request_timeout = env.timeout)
        resp = HTTPC.get(complete_url, ro)

        sqsresp.http_code = resp.http_code
        sqsresp.headers = resp.headers
        sqsresp.body = bytestring(resp.body)

        if (env.dbg)
            print("HTTPCode: ", sqsresp.http_code, "\nHeaders: ", sqsresp.headers, "\nBody : ", sqsresp.body, "\n")
        end

        if (resp.http_code >= 200) && (resp.http_code <= 299)
#             println(typeof(resp.headers))

             if (search(Base.get(resp.headers, "Content-Type", [""])[1], "/xml") != 0:-1)
#            if  haskey(resp.headers, "Content-Type") && (resp.headers["Content-Type"] == "application/xml")
                sqsresp.pd = xp_parse(sqsresp.body)
            end
        elseif (resp.http_code >= 400) && (resp.http_code <= 599)
            if length(sqsresp.body) > 0
                xom = xp_parse(sqsresp.body)
                epd = LibExpat.find(xom, "Error[1]")
                sqsresp.obj = SQSError(LibExpat.find(epd, "Type#string"), LibExpat.find(epd, "Code#string"), LibExpat.find(epd, "Message#string"), LibExpat.find(epd, "Detail#string"), LibExpat.find(xom, "RequestId#string"))
            else
                error("HTTP error : $(resp.http_code)")
            end
        else
            error("HTTP error : $(resp.http_code), $(sqsresp.body)")
        end
    end

    sqsresp
end

include("sqs_typed.jl")


end
