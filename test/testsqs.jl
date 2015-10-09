using AWS.SQS
using AWS

env=AWSEnv()

qurl=nothing
try
    attributes = AttributeType[]
    push!(attributes, AttributeType(name="DelaySeconds",value="0"))
    push!(attributes, AttributeType(name="VisibilityTimeout",value="120"))
    resp = CreateQueue(env; queueName="sqstest", attributeSet=attributes).obj
    if isa(resp, SQSError)
        throw(resp)
    end
    qurl = resp.queueUrl

    resp = GetQueueUrl(env; queueName="sqstest").obj
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

    msgAttributes = MessageAttributeType[]
    push!(msgAttributes, MessageAttributeType(name="some-attribute",
      value=MessageAttributeValueType(dataType="Number.subtype", stringValue="0")))
    push!(msgAttributes, MessageAttributeType(name="other-attribute",
      value=MessageAttributeValueType(dataType="String.yyy", stringValue="My yyy string")))
    push!(msgAttributes, MessageAttributeType(name="bin-attribute",
      value=MessageAttributeValueType(dataType="Binary.jpg", binaryValue=[0x0,0x1,0x2,0x3,0x4,0x5,0x6])))
    SendMessage(env; queueUrl=qurl, delaySeconds=5, messageBody="test", messageAttributeSet=msgAttributes)

    resp = GetQueueAttributes(env; queueUrl=qurl, attributeNameSet=["ApproximateNumberOfMessagesDelayed"]).obj
    if isa(resp, SQSError)
        throw(resp)
    end
    if parse(Int,resp.attributeSet[1].value) != 1
        println("ERROR : Expected one delayed message")
    end

    msgAttributes = MessageAttributeType[]
    push!(msgAttributes, MessageAttributeType(name="bin-attribute",
      value=MessageAttributeValueType(dataType="Binary.jpg", binaryValue=[0x0,0x1,0x2,0x3,0x4,0x5,0x6])))
    SendMessage(env; queueUrl=qurl, messageBody="binary message", messageAttributeSet=msgAttributes)
    resp = ReceiveMessage(env; queueUrl=qurl, messageAttributeNameSet=["All"]).obj
    if resp.messageSet[1].body != "binary message"
        println("ERROR : Send / receive message mismatch")
    end
    if resp.messageSet[1].messageAttributeSet[1].value.binaryValue != [0x0,0x1,0x2,0x3,0x4,0x5,0x6]
        println("ERROR : Send / receive message attribute mismatch")
    end

catch e
    println("ERROR: $e")
end

DeleteQueue(env, queueUrl=qurl)
nothing
