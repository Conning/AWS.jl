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


type GetQueueUrlType
    queueName::Union{ASCIIString, Void}
    queueOwnerAWSAccountId::Union{ASCIIString, Void}

    GetQueueUrlType(; queueName=nothing, queueOwnerAWSAccountId=nothing) =
         new(queueName, queueOwnerAWSAccountId)
end
function GetQueueUrlType(pd::ETree)
    o = GetQueueUrlType()
    o.queueName = LibExpat.find(pd, "queueName#string")
    o.queueOwnerAWSAccountId = LibExpat.find(pd, "queueOwnerAWSAccountId#string")
    o
end

export GetQueueUrlType


type GetQueueUrlResponseType
    queueUrl::Union{ASCIIString, Void}
    requestId::Union{ASCIIString, Void}

    GetQueueUrlResponseType(; queueUrl=nothing, requestId=nothing) =
         new(queueUrl, requestId)
end
function GetQueueUrlResponseType(pd::ETree)
    o = GetQueueUrlResponseType()
    o.queueUrl = LibExpat.find(pd, "GetQueueUrlResult/QueueUrl#string")
    o.requestId = LibExpat.find(pd, "ResponseMetadata/RequestId#string")
    o
end

export GetQueueUrlResponseType


type ListQueuesType
    queueNamePrefix::Union{ASCIIString, Void}

    ListQueuesType(; queueNamePrefix=nothing) =
         new(queueNamePrefix)
end
function ListQueuesType(pd::ETree)
    o = ListQueuesType()
    o.queueName = LibExpat.find(pd, "queueNamePrefix#string")
    o
end

export ListQueuesType


type ListQueuesResponseType
    queueUrlSet::Union{Vector{ASCIIString}, Void}
    requestId::Union{ASCIIString, Void}

    ListQueuesResponseType(; queueUrlSet=nothing, requestId=nothing) =
         new(queueUrlSet, requestId)
end
function ListQueuesResponseType(pd::ETree)
    o = ListQueuesResponseType()
    o.queueUrlSet = ASCIIString[url.elements[1] for url in LibExpat.find(pd, "ListQueuesResult/QueueUrl")]
    o.requestId = LibExpat.find(pd, "ResponseMetadata/RequestId#string")
    o
end

export ListQueuesResponseType


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
