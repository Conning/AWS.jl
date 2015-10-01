type CreateQueueType
    queueName::Union{ASCIIString, Void}

    CreateQueueType(; queueName=nothing) =
         new(queueName)
end
function CreateQueueType(pd::ETree)
    o = CreateQueueType()
    o.queueName = LibExpat.find(pd, "queueName#string")
    o
end

export CreateQueueType


type CreateQueueResponseType
    queueUrl::Union{ASCIIString, Void}
    requestId::Union{ASCIIString, Void}

    CreateQueueResponseType(; queueUrl=nothing, requestId=nothing) =
         new(requestId, queueUrl)
end
function CreateQueueResponseType(pd::ETree)
    o = CreateQueueResponseType()
    o.queueUrl = LibExpat.find(pd, "CreateQueueResult/QueueUrl#string")
    o.requestId = LibExpat.find(pd, "ResponseMetadata/RequestId#string")
    o
end

export CreateQueueResponseType


type DeleteQueueType
    queueUrl::Union{ASCIIString, Void}

    DeleteQueueType(; queueUrl=nothing) =
         new(queueUrl)
end
function DeleteQueueType(pd::ETree)
    o = DeleteQueueType()
    o.queueUrl = LibExpat.find(pd, "queueUrl#string")
    o
end

export DeleteQueueType


type DeleteQueueResponseType
    requestId::Union{ASCIIString, Void}

    DeleteQueueResponseType(; requestId=nothing) =
         new(requestId)
end
function DeleteQueueResponseType(pd::ETree)
    o = DeleteQueueResponseType()
    o.requestId = LibExpat.find(pd, "ResponseMetadata/RequestId#string")
    o
end

export DeleteQueueResponseType
