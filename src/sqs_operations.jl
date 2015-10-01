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


ValidRqstMsgs = Dict(
    "CreateQueueType"=>true,
    "DeleteQueueType"=>true
)
