function CreateQueue(env::AWSEnv, msg::CreateQueueType)
    sqsresp::SQSResponse = call_sqs(env, "CreateQueue" , msg)
    if  (sqsresp.pd != nothing) && (sqsresp.obj == nothing)
        sqsresp.obj = CreateQueueResponseType(sqsresp.pd)
    end
    sqsresp
end
function CreateQueue(env::AWSEnv; kwargs...)
    msg=CreateQueueType()
    for p in kwargs
        setfield!(msg, p[1], p[2])
    end
    CreateQueue(env, msg)
end
export CreateQueue


function DeleteQueue(env::AWSEnv, msg::DeleteQueueType)
    sqsresp::SQSResponse = call_sqs(env, "DeleteQueue" , msg)
    if  (sqsresp.pd != nothing) && (sqsresp.obj == nothing)
        sqsresp.obj = DeleteQueueResponseType(sqsresp.pd)
    end
    sqsresp
end
function DeleteQueue(env::AWSEnv; kwargs...)
    msg=DeleteQueueType()
    for p in kwargs
        setfield!(msg, p[1], p[2])
    end
    DeleteQueue(env, msg)
end
export DeleteQueue


function GetQueueUrl(env::AWSEnv, msg::GetQueueUrlType)
    sqsresp::SQSResponse = call_sqs(env, "GetQueueUrl" , msg)
    if  (sqsresp.pd != nothing) && (sqsresp.obj == nothing)
        sqsresp.obj = GetQueueUrlResponseType(sqsresp.pd)
    end
    sqsresp
end
function GetQueueUrl(env::AWSEnv; kwargs...)
    msg=GetQueueUrlType()
    for p in kwargs
        setfield!(msg, p[1], p[2])
    end
    GetQueueUrl(env, msg)
end
export GetQueueUrl


function ListQueues(env::AWSEnv, msg::ListQueuesType)
    sqsresp::SQSResponse = call_sqs(env, "ListQueues" , msg)
    if  (sqsresp.pd != nothing) && (sqsresp.obj == nothing)
        sqsresp.obj = ListQueuesResponseType(sqsresp.pd)
    end
    sqsresp
end
function ListQueues(env::AWSEnv; kwargs...)
    msg=ListQueuesType()
    for p in kwargs
        setfield!(msg, p[1], p[2])
    end
    ListQueues(env, msg)
end
export ListQueues


ValidRqstMsgs = Dict(
    "CreateQueueType"=>true,
    "GetQueueUrlType"=>true,
    "ListQueuesType"=>true,
    "DeleteQueueType"=>true
)
