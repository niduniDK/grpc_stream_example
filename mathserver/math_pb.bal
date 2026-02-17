import ballerina/grpc;
import ballerina/grpc.types.wrappers as swrappers;
import ballerina/protobuf;
import ballerina/protobuf.types.wrappers;

public const string MATH_DESC = "0A0A6D6174682E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F223D0A0B4D6174685265717565737412160A0676616C756531180120012805520676616C75653112160A0676616C756532180220012805520676616C75653232FF010A0A43616C63756C61746F7212350A086D756C7469706C79120C2E4D617468526571756573741A1B2E676F6F676C652E70726F746F6275662E496E74333256616C756512410A0373756D121B2E676F6F676C652E70726F746F6275662E496E74333256616C75651A1B2E676F6F676C652E70726F746F6275662E496E74333256616C7565280112320A036F6464120C2E4D617468526571756573741A1B2E676F6F676C652E70726F746F6275662E496E74333256616C7565300112430A036D6178121B2E676F6F676C652E70726F746F6275662E496E74333256616C75651A1B2E676F6F676C652E70726F746F6275662E496E74333256616C756528013001620670726F746F33";

public isolated client class CalculatorClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, MATH_DESC);
    }

    isolated remote function multiply(MathRequest|ContextMathRequest req) returns int|grpc:Error {
        map<string|string[]> headers = {};
        MathRequest message;
        if req is ContextMathRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Calculator/multiply", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <int>result;
    }

    isolated remote function multiplyContext(MathRequest|ContextMathRequest req) returns wrappers:ContextInt|grpc:Error {
        map<string|string[]> headers = {};
        MathRequest message;
        if req is ContextMathRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("Calculator/multiply", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <int>result, headers: respHeaders};
    }

    isolated remote function sum() returns SumStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("Calculator/sum");
        return new SumStreamingClient(sClient);
    }

    isolated remote function odd(MathRequest|ContextMathRequest req) returns stream<int, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        MathRequest message;
        if req is ContextMathRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("Calculator/odd", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        swrappers:IntStream outputStream = new swrappers:IntStream(result);
        return new stream<int, grpc:Error?>(outputStream);
    }

    isolated remote function oddContext(MathRequest|ContextMathRequest req) returns wrappers:ContextIntStream|grpc:Error {
        map<string|string[]> headers = {};
        MathRequest message;
        if req is ContextMathRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("Calculator/odd", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        swrappers:IntStream outputStream = new swrappers:IntStream(result);
        return {content: new stream<int, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function max() returns MaxStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("Calculator/max");
        return new MaxStreamingClient(sClient);
    }
}

public isolated client class SumStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendInt(int message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextInt(wrappers:ContextInt message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveInt() returns int|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <int>payload;
        }
    }

    isolated remote function receiveContextInt() returns wrappers:ContextInt|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <int>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class MaxStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendInt(int message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextInt(wrappers:ContextInt message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveInt() returns int|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <int>payload;
        }
    }

    isolated remote function receiveContextInt() returns wrappers:ContextInt|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <int>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class CalculatorIntCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendInt(int response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextInt(wrappers:ContextInt response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextMathRequest record {|
    MathRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: MATH_DESC}
public type MathRequest record {|
    int value1 = 0;
    int value2 = 0;
|};
