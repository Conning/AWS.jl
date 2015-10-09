using AWS.SQS
using AWS

env=AWSEnv()

qurl=nothing
try
    attributes = AttributeType[]
    push!(attributes, AttributeType(name="DelaySeconds",value="0"))
    push!(attributes, AttributeType(name="VisibilityTimeout",value="120"))
    resp = CreateQueue(env, queueName="sqstest", attributeSet=attributes).obj
    if isa(resp, SQSError)
        throw(resp)
    end
    qurl = resp.queueUrl

    resp = GetQueueUrl(env, queueName="sqstest").obj
    if isa(resp, SQSError)
        throw(resp)
    end
    if qurl != resp.queueUrl
        println("ERROR : Mismatch between queueUrl returned by CreateQueue and GetQueueUrl")
    end

    resp = ListQueues(env).obj
    if isa(resp, SQSError)
        throw(resp)
    end
    if !in(qurl, resp.queueUrlSet)
        println("ERROR : Can't find new queue in response from ListQueues")
        dump(resp.queueUrlSet)
    end
catch e
    println("ERROR: $e")
end

DeleteQueue(env, queueUrl=qurl)
nothing
