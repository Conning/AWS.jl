type AttributeType
    name::Union{ASCIIString, Void}
    value::Union{ASCIIString, Void}

    AttributeType(; name=nothing, value=nothing) =
         new(name, value)
end
function AttributeType(pd::ETree)
    o = AttributeType()
    o.name = LibExpat.find(pd, "Name#string")
    o.value = LibExpat.find(pd, "Value#string")
    o
end

export AttributeType


type CreateQueueType
    queueName::Union{ASCIIString, Void}
    attributeSet::Union{Vector{AttributeType}, Void}

    CreateQueueType(; queueName=nothing, attributeSet=nothing) =
         new(queueName, attributeSet)
end
function CreateQueueType(pd::ETree)
    o = CreateQueueType()
    o.queueName = LibExpat.find(pd, "QueueName#string")
    o.attributeSet = AWS.@parse_vector(AWS.SQS.AttributeType, LibExpat.find(pd, "Attribute"))
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
    o.queueName = LibExpat.find(pd, "QueueName#string")
    o.queueOwnerAWSAccountId = LibExpat.find(pd, "QueueOwnerAWSAccountId#string")
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
    o.queueName = LibExpat.find(pd, "QueueNamePrefix#string")
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
    o.queueUrlSet = ASCIIString[LibExpat.find(url, "#string") for url in LibExpat.find(pd, "ListQueuesResult/QueueUrl")]
    o.requestId = LibExpat.find(pd, "ResponseMetadata/RequestId#string")
    o
end

export ListQueuesResponseType


# ChangeMessageVisibilityType
# ChangeMessageVisibilityResponseType

# DeleteMessageType
# DeleteMessageResponseType

type DeleteQueueType
    queueUrl::Union{ASCIIString, Void}

    DeleteQueueType(; queueUrl=nothing) =
         new(queueUrl)
end
function DeleteQueueType(pd::ETree)
    o = DeleteQueueType()
    o.queueUrl = LibExpat.find(pd, "QueueUrl#string")
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


type GetQueueAttributesType
    attributeNameSet::Union{Vector{ASCIIString}, Void}
    queueUrl::Union{ASCIIString, Void}

    GetQueueAttributesType(; attributeNameSet=nothing, queueUrl=nothing) =
         new(attributeNameSet, queueUrl)
end
function GetQueueAttributesType(pd::ETree)
    o = GetQueueAttributesType()
    o.attributeNameSet = AWS.@parse_vector(ASCIIString, LibExpat.find(pd, "AttributeName"))
    o.queueUrl = LibExpat.find(pd, "QueueUrl#string")
    o
end

export GetQueueAttributesType


type GetQueueAttributesResponseType
    attributeSet::Union{Vector{AttributeType}, Void}
    requestId::Union{ASCIIString, Void}

    GetQueueAttributesResponseType(; attributeSet=nothing, requestId=nothing) =
         new(attributeSet, requestId)
end
function GetQueueAttributesResponseType(pd::ETree)
    o = GetQueueAttributesResponseType()
    o.attributeSet = AWS.@parse_vector(AWS.SQS.AttributeType, LibExpat.find(pd, "GetQueueAttributesResult/Attribute"))
    o.requestId = LibExpat.find(pd, "ResponseMetadata/RequestId#string")
    o
end

export GetQueueAttributesResponseType
