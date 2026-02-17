import ballerina/log;
import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: MATH_DESC}
service "Calculator" on ep {

    remote function multiply(MathRequest value) returns int|error {
        return value.value1 * value.value2;
    }
    
    remote function sum(stream<int, grpc:Error?> clientStream) returns int|error {
        int sum = 0;
        check clientStream.forEach(function(int value) {
            sum = sum + value;
        });
        return sum;
    }

    remote function odd(MathRequest value) returns stream<int, error?>|error {
        int[] odds = [];
        int startVal = value.value1;
        while(startVal < value.value2) {
            if (startVal % 2 != 0) {
                odds.push(startVal);
            }
            startVal += 1;
        }
        return odds.toStream();
    }

    remote function max(CalculatorIntCaller caller, stream<int, grpc:Error?> clientStream) returns error? {

        int currentMax = 0;
        check clientStream.forEach(function(int value) {
            log:printInfo("Received:", value=value);
            if (value > currentMax) {
                currentMax = value;
                checkpanic caller->sendInt(value);
            }
            
        });
        check caller->complete();
    }
}