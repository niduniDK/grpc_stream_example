import ballerina/grpc;
import ballerina/io;
CalculatorClient ep = check new ("http://localhost:9090");

public function main() returns error? {

    MathRequest request = {value1: 10, value2: 30};

    //Simple RPC
    io:println("---Simple RPC---");
    int multiplyRes = check ep->multiply(request);
    io:println("Multiply:", multiplyRes);

    //Client Side Streaming
    io:println("---Client Side Streaming---");
    SumStreamingClient sumStreamingClient = check ep->sum();
    int[] sumValues = [1, 34, 32, 2, 1];
    foreach int val in sumValues {
        check sumStreamingClient->sendInt(val);
    }
    check sumStreamingClient->complete();
    int? receiveInt = check sumStreamingClient->receiveInt();
    if !(receiveInt is ()) {
        io:println("Sum is : ", receiveInt);
    }

    //Server side Streaming
    io:println("---Server Side Streaming---");
    stream<int, grpc:Error?> streamResult = check ep->odd(request);
    check streamResult.forEach(function(int i) {
        io:println("Odd numbers are :", i);
    });

    //Bi-directional Streaming
    io:println("---Bi-directional Streaming---");
    MaxStreamingClient maxStreamingClient =  check ep->max();

    int[] inputValues = [1, 4, 2, 5, 3, 33, 32, 44, 5, 39];

    future<error?> f1 = start readResponse(maxStreamingClient);

    foreach int val in inputValues {
        io:println("Send value to get max:", val);
        check maxStreamingClient->sendInt(val);
    }

    check maxStreamingClient->complete();

    check wait f1;
}

//Function to receive response.
function readResponse(MaxStreamingClient maxStreamingClient) returns error? {
    int? result = check maxStreamingClient->receiveInt();
    while !(result is ()) {
        io:println("Max Received:", result);
        result = check maxStreamingClient->receiveInt();
    }
}