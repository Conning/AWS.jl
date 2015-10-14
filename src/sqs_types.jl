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


# Note: dataType="Binary" is not supported because HTTPC.urlencode_query_params is not presently capable of encoding binary data into a URL.
# Need to either enhance HTTPClient package, or place binary data into POST message instead of GET.
type MessageAttributeValueType
    dataType::Union{AbstractString, Void}
    binaryValue::Union{Vector{UInt8}, Void}
    stringValue::Union{AbstractString, Void}

    MessageAttributeValueType(; dataType=nothing, binaryValue=nothing, stringValue=nothing) =
         new(dataType, binaryValue, stringValue)
end
function MessageAttributeValueType(pd::ETree)
    o = MessageAttributeValueType()
    o.dataType = LibExpat.find(pd, "DataType#string")
    o.binaryValue = AWS.safe_parseb64(LibExpat.find(pd, "BinaryValue#string"))
    o.stringValue = LibExpat.find(pd, "StringValue#string")
    o
end

export MessageAttributeValueType


type MessageAttributeType
    name::Union{ASCIIString, Void}
    value::Union{MessageAttributeValueType, Void}

    MessageAttributeType(; name=nothing, value=nothing) =
         new(name, value)
end
function MessageAttributeType(pd::ETree)
    o = MessageAttributeType()
    o.name = LibExpat.find(pd, "Name#string")
    o.value = MessageAttributeValueType(LibExpat.find(pd, "Value[1]"))
    o
end

export MessageAttributeType


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
         new(queueUrl, requestId)
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

type DeleteMessageType
    queueUrl::Union{ASCIIString, Void}
    receiptHandle::Union{ASCIIString, Void}

    DeleteMessageType(; queueUrl=nothing, receiptHandle=nothing) =
         new(queueUrl, receiptHandle)
end
function DeleteMessageType(pd::ETree)
    o = DeleteMessageType()
    o.queueUrl = LibExpat.find(pd, "QueueUrl#string")
    o.receiptHandle = LibExpat.find(pd, "ReceiptHandle#string")
    o
end

export DeleteMessageType


type DeleteMessageResponseType
    requestId::Union{ASCIIString, Void}

    DeleteMessageResponseType(; requestId=nothing) =
         new(requestId)
end
function DeleteMessageResponseType(pd::ETree)
    o = DeleteMessageResponseType()
    o.requestId = LibExpat.find(pd, "ResponseMetadata/RequestId#string")
    o
end

export DeleteMessageResponseType

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


type ReceiveMessageType
    maxNumberOfMessages::Union{Int, Void}
    visibilityTimeout::Union{Int, Void}
    waitTimeSeconds::Union{Int, Void}
    attributeNameSet::Union{Vector{ASCIIString}, Void}
    messageAttributeNameSet::Union{Vector{ASCIIString}, Void}
    queueUrl::Union{ASCIIString, Void}

    ReceiveMessageType(; maxNumberOfMessages=nothing, visibilityTimeout=nothing, waitTimeSeconds=nothing, attributeNameSet=nothing, messageAttributeNameSet=nothing, queueUrl=nothing) =
         new(maxNumberOfMessages, visibilityTimeout, waitTimeSeconds, attributeNameSet, messageAttributeNameSet, queueUrl)
end
function ReceiveMessageType(pd::ETree)
    o = ReceiveMessageType()
    o.maxNumberOfMessages = AWS.safe_parseint(LibExpat.find(pd, "MaxNumberOfMessages#string"))
    o.visibilityTimeout = AWS.safe_parseint(LibExpat.find(pd, "VisibilityTimeout#string"))
    o.waitTimeSeconds = AWS.safe_parseint(LibExpat.find(pd, "WaitTimeSeconds#string"))
    o.attributeNameSet = AWS.@parse_vector(ASCIIString, LibExpat.find(pd, "AttributeName"))
    o.messageAttributeNameSet = AWS.@parse_vector(ASCIIString, LibExpat.find(pd, "MessageAttributeName"))
    o.queueUrl = LibExpat.find(pd, "QueueUrl#string")
    o
end

export ReceiveMessageType


type MessageType
    messageId::Union{ASCIIString, Void}
    receiptHandle::Union{ASCIIString, Void}
    MD5OfBody::Union{ASCIIString, Void}
    MD5OfMessageAttributes::Union{ASCIIString, Void}
    body::Union{AbstractString, Void}
    attributeSet::Union{Vector{AttributeType}, Void}
    messageAttributeSet::Union{Vector{MessageAttributeType}, Void}

    MessageType(; messageId=nothing, receiptHandle=nothing, MD5OfBody=nothing, MD5OfMessageAttributes=nothing, body=nothing, attributeSet=nothing, messageAttributeSet=nothing) =
        new(messageId, receiptHandle, MD5OfBody, MD5OfMessageAttributes, body, attributeSet, messageAttributeSet)
end
function MessageType(pd::ETree)
    o = MessageType()
    o.messageId = LibExpat.find(pd, "MessageId#string")
    o.receiptHandle = LibExpat.find(pd, "ReceiptHandle#string")
    o.MD5OfBody = LibExpat.find(pd, "MD5OfBody#string")
    o.MD5OfMessageAttributes = LibExpat.find(pd, "MD5OfMessageAttributes#string")
    o.body = LibExpat.find(pd, "Body#string")
    o.attributeSet = AWS.@parse_vector(AWS.SQS.AttributeType, LibExpat.find(pd, "Attribute"))
    o.messageAttributeSet = AWS.@parse_vector(AWS.SQS.MessageAttributeType, LibExpat.find(pd, "MessageAttribute"))
    o
end

export MessageType


type ReceiveMessageResponseType
    messageSet::Union{Vector{MessageType}, Void}
    requestId::Union{ASCIIString, Void}

    ReceiveMessageResponseType(; messageSet=nothing, requestId=nothing) =
         new(messageSet, requestId)
end
function ReceiveMessageResponseType(pd::ETree)
    o = ReceiveMessageResponseType()
    o.messageSet = AWS.@parse_vector(AWS.SQS.MessageType, LibExpat.find(pd, "ReceiveMessageResult/Message"))
    o.requestId = LibExpat.find(pd, "ResponseMetadata/RequestId#string")
    o
end

export ReceiveMessageResponseType


type SendMessageType
    delaySeconds::Union{Int, Void}
    messageAttributeSet::Union{Vector{MessageAttributeType}, Void}
    messageBody::Union{AbstractString, Void}
    queueUrl::Union{ASCIIString, Void}

    SendMessageType(; delaySeconds=nothing, messageBody=nothing, queueUrl=nothing) =
         new(delaySeconds, messageBody, queueUrl)
end
function SendMessageType(pd::ETree)
    o = SendMessageType()
    o.delaySeconds = AWS.safe_parseint(LibExpat.find(pd, "DelaySeconds#string"))
    o.messageAttributeSet = AWS.@parse_vector(AWS.SQS.MessageAttributeType, LibExpat.find(pd, "MessageAttribute"))
    o.messageBody = LibExpat.find(pd, "MessageBody#string")
    o.queueUrl = LibExpat.find(pd, "QueueUrl#string")
    o
end

export SendMessageType


type SendMessageResponseType
    MD5OfMessageBody::Union{ASCIIString, Void}
    MD5OfMessageAttributes::Union{ASCIIString, Void}
    messageId::Union{ASCIIString, Void}
    requestId::Union{ASCIIString, Void}

    SendMessageResponseType(; MD5OfMessageBody=nothing, MD5OfMessageAttributes=nothing, messageId=nothing, requestId=nothing) =
         new(MD5OfMessageBody, MD5OfMessageAttributes, messageId, requestId)
end
function SendMessageResponseType(pd::ETree)
    o = SendMessageResponseType()
    o.MD5OfMessageBody = LibExpat.find(pd, "SendMessageResult/MD5OfMessageBody#string")
    o.MD5OfMessageAttributes = LibExpat.find(pd, "SendMessageResult/MD5OfMessageAttributes#string")
    o.messageId = LibExpat.find(pd, "SendMessageResult/MessageId#string")
    o.requestId = LibExpat.find(pd, "ResponseMetadata/RequestId#string")
    o
end

export SendMessageResponseType


type SetQueueAttributesType
    attributeSet::Union{Vector{AttributeType}, Void}
    queueUrl::Union{ASCIIString, Void}

    SetQueueAttributesType(; attributeSet=nothing, queueUrl=nothing) =
         new(attributeSet, queueUrl)
end
function SetQueueAttributesType(pd::ETree)
    o = SetQueueAttributesType()
    o.attributeSet = AWS.@parse_vector(AWS.SQS.AttributeType, LibExpat.find(pd, "Attribute"))
    o.queueUrl = LibExpat.find(pd, "QueueUrl#string")
    o
end

export SetQueueAttributesType


type SetQueueAttributesResponseType
    requestId::Union{ASCIIString, Void}

    SetQueueAttributesResponseType(; requestId=nothing) =
         new(requestId)
end
function SetQueueAttributesResponseType(pd::ETree)
    o = SetQueueAttributesResponseType()
    o.requestId = LibExpat.find(pd, "ResponseMetadata/RequestId#string")
    o
end

export SetQueueAttributesResponseType
