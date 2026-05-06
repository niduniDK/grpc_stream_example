import ballerina/http;

listener http:Listener probeEP = check new (7040);

service / on probeEP {
    resource function get healthz() returns string {
        string message = string `Hello from ${7040}"}`;
        return message;
    }

}
